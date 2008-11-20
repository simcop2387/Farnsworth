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
		if (!defined($v))# || ($v->{dimen}{dimen}{"undef"})) #uncomment for undef== default value
		{
			#i need a default value!
			if (!defined($argtypes->[$argc][1]) && defined($argtypes->[$argc][0])  && (defined($const) && ref($const) ne "Math::Farnsworth::Value" && $const ne "VarArg"))
			{
				die "Required argument $argc to function $name\[\] missing\n";
			}

			$v = $argtypes->[$argc][1];
		}

		if (defined($const) && ref($const) eq "Math::Farnsworth::Value")
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

		$vars->declare($n, $v) if defined $n; #happens when no arguments!
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

	#print "-------------ATTEMPTING TO CALL FUNCTION!-------------\n";
	#print "FUNCTION NAME : $name\n";
	#print "Dumper of func: ".Dumper($fval);
	#print "--------------------THAT IS ALL\n";

	die "Function $name is not defined\n" unless defined($fval);
	die "Number of arguments not correct to $name\[\]\n" unless $self->checkparams($args, $argtypes); #this should check....

#	print Dumper($args);

	my $nvars = new Math::Farnsworth::Variables($eval->{vars});

	my %nopts = (vars => $nvars, funcs => $self, units => $eval->{units}, parser => $eval->{parser});
	my $neval = $eval->new(%nopts);

	$self->setupargs($neval, $args, $argtypes, $name); #setup the arguments

	if (ref($fval) ne "CODE")
	{

		return $self->callbranch($neval, $fval);
	}
	else
	{
		#we have a code ref, so we need to call it
		return $fval->($args, $neval, $branches);
	}
}

sub calllambda
{
	my $self = shift;
	my $lambda = shift;
	my $args = shift;

	my $argtypes = $lambda->{pari}{args};
	my $fval = $lambda->{pari}{code};
    my $eval = $lambda->{pari}{scope};

	#print "LAMBDA---------------\n";
	#print Dumper($argtypes, $args, $fval);

	die "Number of arguments not correct to lambda\n" unless $self->checkparams($args, $argtypes); #this shoul

	$self->setupargs($eval, $args, $argtypes, "lambda");
	return $self->callbranch($eval, $fval);
}

sub callbranch
{
	my $self = shift;
	my $eval = shift;
	my $branches = shift;

	return $eval->evalbranch($branches);
}

#this was supposed to be the checks for types and such, but now its something else entirely, mostly
sub checkparams 
{
	my $self = shift;
	my $args = shift;
	my $argtypes = shift;

	my $vararg = 0;

	my $neededargs = 0;
	my $badargs = 0;

	for my $argt (@$argtypes)
	{
		$neededargs++ unless (defined($argt->[1]) || !defined($argt->[0]));
		$badargs++ if (!defined($argt->[0]));
	}

	$vararg = 1 if (grep {defined($_->[2]) && ref($_->[2]) ne "Math::Farnsworth::Value" && ($_->[2] eq "VarArg")} @{$argtypes}); #find out if there is a vararg arg

	#print "NEEDED: $neededargs\n";
	#print Data::Dumper->Dump([$argtypes, $args->{pari}], [qw(argtypes args)]);

    return 1 if ($vararg || (@{$args->{pari}} <= (@{$argtypes}-$badargs) && @{$args->{pari}} >= $neededargs));

	#return 0 unless (ref($args) eq "Math::Farnsworth::Value") && ($args->{dimen}->compare({dimen=>{array=>1}}));

	return 0;
}

1;
