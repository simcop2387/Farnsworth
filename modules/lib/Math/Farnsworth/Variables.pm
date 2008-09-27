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
	my $self = {parent => undef, vars => {}};
	$self->{parent} = $state if (ref($state) eq "Math::Farnsworth::Variables");
	bless $self;
}

sub setvar
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	if ((exists($self->{vars}{$name})) || !defined($self->{parent}))
	{
		$self->{vars}{$name} = $value;
	}
	else
	{
		$self->{parent}->setvar($name, $value); #set it in the previous scope
	}
}

sub declare
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	#really all we need to do is just set it in this scope to see it
	$self->{vars}{$name} = $value;
}

sub getvar
{
	my $self = shift;
	my $name = shift;
	my $val;

	if (exists($self->{vars}{$name}))
	{
		$val = $self->{vars}{$name};
	}
	elsif (defined($self->{parent}))
	{
		$val = $self->{parent}->getvar($name);
	}

	return $val;
}

sub isvar
{
	my $self = shift;
	my $name = shift;

	my $r = exists($self->{vars}{$name});

	if (!exists($self->{vars}{$name}) && defined($self->{parent}))
	{
		$r = $self->{parent}->isvar($name);
	}

	return $r;
}
1;
