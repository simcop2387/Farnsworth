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

	if (ref($opts{units}) eq "Math::Farnsworth::Units")
	{
		$self->{units} = $opts{units};
	}
	else
	{
		$self->{units} = new Math::Farnsworth::Units();
	}

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
	elsif ($type eq "Pow")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a ** $b;
	}
	elsif ($type eq "Gt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a > $b;
	}
	elsif ($type eq "Lt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a < $b;
	}
	elsif ($type eq "Ge")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a >= $b;
	}
	elsif ($type eq "Le")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a <= $b;
	}
	elsif ($type eq "Compare")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a <=> $b;
	}
	elsif ($type eq "Eq")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a == $b;
	}
	elsif ($type eq "Ne")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a != $b;
	}
	elsif ($type eq "Ternary")
	{
		#turing completeness FTW
		#wtf? for some reason i have to do this...
		$return = $self->makevalue($branch->[0]) ? $self->makevalue($branch->[1]) : $self->makevalue($branch->[2]);
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
		print Dumper($branch);
		my $name = $branch->[0];
		my $args = $branch->[1];
		my $value = $branch->[2]; #not really a value, but in fact the tree to run for the function

		$self->{funcs}->addfunc($name, $args, $value);
		$return = undef; #cause an error should someone manage to make it parse other than the way i think it should be
	}
	elsif ($type eq "FuncCall")
	{
		my $name = $branch->[0];
		my $args = $self->makevalue($branch->[1]); #this is an array, need to evaluate it

		$return = $self->{funcs}->callfunc($self, $name, $args);

	}
	elsif ($type eq "Array")
	{
		for my $bs (@$branch) #iterate over all the elements
		{
			push @$return, $self->makevalue($bs); #we return an array ref! i need more error checking around for this later
		}
	}
	elsif ($type eq "Stmt")
	{
		for my $bs (@$branch) #iterate over all the statements
		{   my $r = $self->makevalue($bs);
			$return = $r if defined $r; #this has interesting semantics!
		}
	}
	elsif ($type eq "Paren")
	{
		$return = $self->makevalue($branch->[0]);
	}
	elsif ($type eq "SetDisplay")
	{
	}
	elsif ($type eq "UnitDef")
	{
		my $unitsize = $self->makevalue($branch->[1]);
		my $name = $branch->[0];
		$self->{units}->addunit($name, $unitsize);
	}
	elsif ($type eq "DefineDimen")
	{
		my $unit = $branch->[1];
		my $dimen = $branch->[0];
		$self->{units}->adddimen($dimen, $unit);
	}
	elsif (($type eq "SetPrefix") || ($type eq "SetPrefixAbrv"))
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);
		print "SETTING PREFIX0: $name : $value : ".Dumper($branch->[1]) if ($name eq "m");
		$self->{units}->setprefix($name, $value);
	}
	elsif ($type eq "Trans")
	{
		my $left = $self->makevalue($branch->[0]);
		my $right = $self->makevalue($branch->[1]);
		$return = ($left / $right);
	}
	elsif ($type eq "String")
	{
		$return = $branch->[0];
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

		my $name = $input->[0];
		if ($self->{vars}->isvar($name))
		{
			return $self->{vars}->getvar($input->[0]);
		}
		elsif ($self->{units}->isunit($name))
		{
			print "FETCH: $name\n" if ($name eq "milli");
			return $self->{units}->getunit($name);
		}
		
		die "Undefined symbol '$name'";
	}
#	elsif (ref($input) eq "String") #we've got a string that should be a value!
#	{
#	}

	return $self->evalbranch($input);
}

1;
