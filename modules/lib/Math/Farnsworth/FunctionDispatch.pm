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

	print Dumper($args);

	if (ref($fval) ne "CODE")
	{
		my $nvars = new Math::Farnsworth::Variables($eval->{vars});
		for my $argc (0..$#$argtypes)
		{
			print "-----FUNCCALL\n";
			print Dumper($args);
			my $n = $argtypes->[$argc][0]; #the rest are defaults and constraints
			my $v = $args->{pari}->[$argc];

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

#this should check for correctness of types and such, todo later
#also should check for number of params
sub checkparams 
{
	return 1 unless (ref($_[1]) eq "Math::Farnsworth::Value") && (ref($_[1]->{pari}) eq "ARRAY");
	return 0;
}

1;
