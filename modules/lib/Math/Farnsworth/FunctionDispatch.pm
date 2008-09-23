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

	my $argtypes = $self->{funcs}{$name}{args};

	die "Arguments not correct" unless $self->checkparams($name, $args); #this should check....

	print Dumper($args);

	my $nvars = new Math::Farnsworth::Variables($eval->{vars});
	for my $argc (0..$#$argtypes)
	{
		my $n = $argtypes->[$argc][0]; #the rest are defaults and types
		my $v = $args->[$argc];

		$nvars->setvar($n, $v);
	}
	my %nopts = (vars => $nvars, funcs => $self, units => $eval->{units}, parser => $eval->{parser});
    my $neval = $eval->new(%nopts);

	print Dumper($self->{funcs}{$name}{value});

	return $neval->evalbranch($self->{funcs}{$name}{value});
}

#this should check for correctness of types and such, todo later
#also should check for number of params
sub checkparams 
{
	return 1;
}

1;