package Math::Farnsworth::Variables;

use strict;
use warnings;

use Data::Dumper;

#this is very simple right now but i'll need to make a way to inherit
#variables from an old Math::Farnsworth::Variables class so that i can do
#functions with "scoping"

sub new
{
	my $class = shift;
	my $state = shift;
	my $self = {};
	$self = {%$state} if (ref($state) eq "Math::Farnsworth::Variables");
	bless $self;
}

sub setvar
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	$self->{$name} = $value;
}

sub getvar
{
	my $self = shift;
	my $name = shift;
	my $val = $self->{$name};

	return $val;
}

1;
