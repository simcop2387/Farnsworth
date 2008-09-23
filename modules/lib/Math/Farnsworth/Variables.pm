package Math::Farnsworth::Variables;

use strict;
use warnings;

use Data::Dumper;

#this is very simple right now but i'll need to make a way to inherit
#variables from an old Math::Farnsworth::Variables class so that i can do
#functions with "scoping"

sub new
{
	my $self = {};
	bless $self;
}

sub setvar
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	print "Storing [$name] as :".Dumper($value);

	$self->{$name} = $value;
}

sub getvar
{
	my $self = shift;
	my $name = shift;
	my $val = $self->{$name};

	print "Getting [$name] as :".Dumper($val);

	return $val;
}

1;
