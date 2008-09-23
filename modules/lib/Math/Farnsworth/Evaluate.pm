#!/usr/bin/perl

package Math::Farnsworth::Evaluate;

use strict;
use warnings;

use Data::Dumper;

use Math::Farnsworth::FunctionDispatch;
use Math::Farnsworth::Variables;
use Math::Farnsworth::Units;
use Math::Farnsworth::Parser;
use Math::Farnsworth::Value;

sub new
{
	my $self = {};
	bless $self, (shift);

	$self->{funcs} = new Math::Farnsworth::FunctionDispatch();
	$self->{vars} = new Math::Farnsworth::Variables();
	$self->{units} = new Math::Farnsworth::Units(); #this should do prefixes also
	$self->{parser} = new Math::Farnsworth::Parser();
}

sub eval
{
	my $self = shift;
	my $code = shift; #i should probably take an array, so i can use arrays of things, but that'll be later

	my $tree = $self->{parser}->parse($code); #should i catch the exceptions here? dunno

    $self->evalbranch($tree);
}

#evaluate a single branch
sub evalbranch
{
	my $self = shift;

	my $branch = shift;
	my $type = ref($branch); #this'll grab what kind from the bless on the tree

	my $return; #to make things simpler later on

	if ($type eq "Add")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a + $b;
	}
	elsif ($type eq "Sub")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a - $b;
	}

	return $return;
}

sub makevalue
{
	my $self = shift;
	my $input = shift;

	if (ref($input))
	{
		return $self->evalbranch($input);
	}

	#need to make a value here with Math::Farnsworth::Value!
	my $val = new Math::Farnsworth::Value($input);
	return $val;
}
