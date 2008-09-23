package Math::Farnsworth::FunctionDispatch;

use strict;
use warnings;

sub new
{
	my $self = {};
	bless $self, (shift);
}

sub addfunc
{
	my $self = shift;
    my $fundef = shift; #this should be a parse tree one
	my $name = $fundef->[0];
	my $args = $fundef->[1];
	my $value = $fundef->[2];

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
sub evalfunc
{
	my $self = shift;
	my $eval = shift;
	my $name = shift;
	my $args = shift;

	my $nvars = new Math::Farnsworth::Variables($eval->{vars});
	my %nopts = (vars => $nvars, funcs => $self, units => $eval->{units}, parser => $eval->{parser});
    my $neval = $eval->new(%nopts);

	return $neval->eval($self->{$name}{value});
}

#this should check for correctness of types and such, todo later
#also should check for number of params
sub checkparams 
{
	return 1;
}

1;
