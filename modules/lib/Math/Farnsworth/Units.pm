package Math::Farnsworth::Units;

use strict;
use warnings;

use Data::Dumper;

sub new
{
	my $self = {};
	bless $self;
}

sub addunit
{
}

sub getunit
{
}

sub adddimen
{
}

#is this useful?
sub getdimen
{
}

#these primarily are used for display purposes
sub addcombo
{
}

#this returns the name of the combo that matches the current dimensions of a Math::Farnsworth::Value
sub findcombo
{
}

#this sets a display for a combo first, then for a dimension
sub setdisplay
{
}

#this takes a set of dimensions and returns what to display
sub getdisplay
{
}
1;
