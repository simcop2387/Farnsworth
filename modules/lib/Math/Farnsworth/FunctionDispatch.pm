package Math::Farnsworth::FunctionDispatch;

use strict;
use warnings;

use Data::Dumper;

use Math::Farnsworth::Variables;
use Math::Farnsworth::Value;

sub new
{
	my $self = {};
	bless $self, (shift);
}

sub addfunc
{
	my $self = shift;
	my $name = shift;
	my $args = shift;
	my $value = shift;

	#i should really have some error checking here
	$self->{funcs}{$name} = {name=>$name, args=>$args, value=>$value};
}

sub getfunc
{
	my $self = shift;
	my $name = shift; #which one to get, we return the hashref
	return $self->{funcs}{$name};
}

sub isfunc
{
	my $self = shift;
	my $name = shift;

	return exists($self->{funcs}{$name});
}

sub setupargs
{
	my $self = shift;
	my $eval = shift;
	my $args = shift;
	my $argtypes = shift;
	my $name = shift; #name to display

	my $vars = $eval->{vars}; #get the scope we need

ARG:for my $argc (0..$#$argtypes)
	{
		my $n = $argtypes->[$argc][0]; #the rest are defaults and constraints
		my $v = $args->{pari}->[$argc];

		my $const = $argtypes->[$argc][2];
		if (!defined($v))
		{
			#i need a default value!
			if (!defined($argtypes->[$argc][1]) && defined($argtypes->[$argc][0])  && (defined($const) && $const ne "VarArg"))
			{
				die "Required argument $argc to function $name\[\] missing\n";
			}

			$v = $argtypes->[$argc][1];
		}

		if (defined($const) && $const ne "VarArg")
		{
			#we have a constraint
			if (!$v->{dimen}->compare($const->{dimen}))
			{
				die "Constraint not met on argument $argc to $name\[\]\n";
			}
		}
		elsif (defined($const) && $const eq "VarArg")
		{
			#we've got a variable argument, it needs to slurp all the rest of the arguments into an array!
			my $last = $#{$args->{pari}};
			my @vargs = @{$args->{pari}}[$argc..$last];
			my $v = new Math::Farnsworth::Value(\@vargs, {array => 1});
			$vars->declare($n, $v); #set the variable
			last ARG; #don't parse ANY more arguments
		}

		$vars->declare($n, $v);
	}
}

#should i really have this here? or should i have it in evaluate.pm?
sub callfunc
{
	my $self = shift;
	my $eval = shift;
	my $name = shift;
	my $args = shift;
	my $branches = shift;

	my $argtypes = $self->{funcs}{$name}{args};

	my $fval = $self->{funcs}{$name}{value};

	print "-------------ATTEMPTING TO CALL FUNCTION!-------------\n";
	print "FUNCTION NAME : $name\n";
	print "Dumper of func: ".Dumper($fval);
	print "--------------------THAT IS ALL\n";

	die "Number of arguments not correct to $name\[\]" unless $self->checkparams($name, $args, $argtypes); #this should check....

#	print Dumper($args);

	my $nvars = new Math::Farnsworth::Variables($eval->{vars});

	my %nopts = (vars => $nvars, funcs => $self, units => $eval->{units}, parser => $eval->{parser});
	my $neval = $eval->new(%nopts);

	$self->setupargs($neval, $args, $argtypes, $name); #setup the arguments

	if (ref($fval) ne "CODE")
	{

		return $neval->evalbranch($fval);
	}
	else
	{
		#we have a code ref, so we need to call it
		return $fval->($args, $neval, $branches);
	}
}

#this was supposed to be the checks for types and such, but now its something else entirely
sub checkparams 
{
	my $self = shift;
    my $name = shift;
	my $args = shift;
	my $argtypes = shift;

	return 0 unless (ref($args) eq "Math::Farnsworth::Value") && ($args->{dimen}->compare({dimen=>{array=>1}}));

	my $vararg = 0;

	$vararg = 1 if (grep {defined($_->[2]) && ($_->[2] eq "VarArg")} @{$argtypes}); #find out if there is a vararg arg

    return 1 if ($vararg || (@{$args->{pari}} == @{$argtypes}));

	return 0;
}

1;
