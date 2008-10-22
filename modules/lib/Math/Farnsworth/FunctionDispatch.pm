package Math::Farnsworth::FunctionDispatch;

use strict;
use warnings;

use Data::Dumper;

use Math::Farnsworth::Variables;

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

	for my $argc (0..$#$argtypes)
	{
		my $n = $argtypes->[$argc][0]; #the rest are defaults and constraints
		my $v = $args->{pari}->[$argc];

		if (!defined($v))
		{
			#i need a default value!
			if (!defined($argtypes->[$argc][1]) && defined($argtypes->[$argc][0]))
			{
				die "Required argument $argc to function $name\[\] missing\n";
			}

			$v = $argtypes->[$argc][1];
		}

		my $const = $argtypes->[$argc][2];
		if (defined($const))
		{
			#we have a constraint
			if (!$v->{dimen}->compare($const->{dimen}))
			{
				die "Constraint not met on argument $argc to $name\[\]\n";
			}
		}

		$nars->declare($n, $v);
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

	die "Arguments not correct" unless $self->checkparams($name, $args); #this should check....

#	print Dumper($args);

	if (ref($fval) ne "CODE")
	{
		my $nvars = new Math::Farnsworth::Variables($eval->{vars});
		for my $argc (0..$#$argtypes)
		{
			my $n = $argtypes->[$argc][0]; #the rest are defaults and constraints
			my $v = $args->{pari}->[$argc];

			if (!defined($v))
			{
				#i need a default value!
				if (!defined($argtypes->[$argc][1]) && defined($argtypes->[$argc][0]))
				{
					die "Required argument $argc to function $name\[\] missing";
				}

				$v = $argtypes->[$argc][1];
			}

			my $const = $argtypes->[$argc][2];
			print Dumper($const);
			if (defined($const))
			{
				#we have a constraint
				if (!$v->{dimen}->compare($const->{dimen}))
				{
					die "Constraint not met on argument to $name\[\] in argument $argc";
				}
			}

			$nvars->declare($n, $v);
			#$nvars->setvar($n, $v);
		}
		my %nopts = (vars => $nvars, funcs => $self, units => $eval->{units}, parser => $eval->{parser});
	    my $neval = $eval->new(%nopts);

		print Dumper($fval);

		return $neval->evalbranch($fval);
	}
	else
	{
		#we have a code ref, so we need to call it
		return $fval->($args, $eval, $branches);
	}
}

#this was supposed to be the checks for types and such, but now its something else entirely
sub checkparams 
{
	return 1 unless (ref($_[1]) eq "Math::Farnsworth::Value") && (ref($_[1]->{pari}) eq "ARRAY");
	return 0;
}

1;
