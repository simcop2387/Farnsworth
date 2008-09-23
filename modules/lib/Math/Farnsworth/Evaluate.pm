#!/usr/bin/perl

package Math::Farnsworth::Evaluate;

use strict;
use warnings;

use Data::Dumper;

use Math::Farnsworth::FunctionDispatch;
use Math::Farnsworth::Variables;
#use Math::Farnsworth::Units;
use Math::Farnsworth::Parser;
use Math::Farnsworth::Value;

sub new
{
    my $class = shift;
	my $self = {};
	bless $self;

	my %opts = (@_);

	if (ref($opts{funcs}) eq "Math::Farnsworth::FunctionDispatch")
	{
		$self->{funcs} = $opts{funcs};
	}
	else
	{
		$self->{funcs} = new Math::Farnsworth::FunctionDispatch();
	}

	if (ref($opts{vars}) eq "Math::Farnsworth::Variables")
	{
		$self->{vars} = $opts{vars};
	}
	else
	{
		$self->{vars} = new Math::Farnsworth::Variables();
	}

#	if (ref($opts{units}) eq "Math::Farnsworth::Units")
#	{
#		$self->{units} = $opts{units};
#	}
#	else
#	{
#		$self->{units} = new Math::Farnsworth::Units();
#	}

	if (ref($opts{parser}) eq "Math::Farnsworth::Parser")
	{
		$self->{parser} = $opts{parser};
	}
	else
	{
		$self->{parser} = new Math::Farnsworth::Parser();
	}

    return $self;
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
	elsif ($type eq "Mul")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a * $b;
	}
	elsif ($type eq "Div")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a / $b;
	}
	elsif ($type eq "Mod")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a % $b;
	}
	elsif ($type eq "Store")
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);
		$return = $value; #make stores evaluate to the value on the right
		$self->{vars}->setvar($name, $value);
	}
	elsif ($type eq "FuncDef")
	{
		my $name = $branch->[0];
		my $args = $branch->[1];
		my $value = $branch->[2]; #not really a value, but in fact the tree to run for the function

	}
	elsif ($type eq "Stmt")
	{
		$return = $self->evalbranch($branch->[0]); #should be good
	}
	elsif ($type eq "Paren")
	{
		$return = $self->evalbranch($branch->[0]);
	}

	return $return;
}

sub makevalue
{
	my $self = shift;
	my $input = shift;

	if (ref($input) eq "Num")
	{
		#need to make a value here with Math::Farnsworth::Value!
		my $val = new Math::Farnsworth::Value($input->[0]);
		return $val;
	}
	elsif (ref($input) eq "Fetch")
	{
		#this needs to decide between variable and unit, but that'll come later
		#esp since i also have to have this overridable for functions!
		my $val = $self->{vars}->getvar($input->[0]);
		return $val;
	}

	return $self->evalbranch($input);
}

1;
