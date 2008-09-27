package Math::Farnsworth::Functions::Standard;

use strict;
use warnings;

use Math::Farnsworth::Value;
use utf8;

sub init
{
   my $env = shift;

   $env->{funcs}->addfunc("push", [],\&push);
   $env->{funcs}->addfunc("pop", [],\&pop);
   $env->{funcs}->addfunc("length", [],\&length);
   #commented out for testing
#   $env->{funcs}->addfunc("substr", [],\&substr);
#   $env->{funcs}->addfunc("substrLen", [],\&substrlen);
#   $env->{funcs}->addfunc("left", [],\&left);
#   $env->{funcs}->addfunc("right", [],\&right);
#   $env->{funcs}->addfunc("reverse", [],\&reverse);
}

sub push
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[1][0][0])))
	{
		die "First argument to push must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[1][0][0]);

	if (!exists($arrayvar->{dimen}{dimen}{array}))
	{
		die "First argument to push must be an array";
	}

	#ok type checking is done, do the push!
	
	my @input = @{$args->{pari}};
	shift @input; #remove the original array value

	#i should probably flatten arrays here so that; a=[1,2,3]; push[a,a]; will result in a = [1,2,3,1,2,3]; instead of a = [1,2,3,[1,2,3]];

	CORE::push @{$arrayvar->{pari}}, @input;

	return undef; #push doesn't return anything? probably should, but i'll do that later
}

sub pop
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[1][0][0])))
	{
		die "Argument to pop must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[1][0][0]);

	if (!exists($arrayvar->{dimen}{dimen}{array}))
	{
		die "Argument to pop must be an array";
	}

	#ok type checking is done, do the pop
	
	my $retval = CORE::pop @{$arrayvar->{pari}};

	return $retval; #pop returns the value of the element removed
}

sub length
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			CORE::push @rets, Math::Farnsworth::Value->new(scalar @{$arg->{pari}}, {});
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			CORE::push @rets, Math::Farnsworth::Value->new(length $arg->{pari}, {});
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(0, {});
		}
	}

	if (@rets > 1)
	{
		return Math::Farnsworth::Value->new(\@rets, {array=>1});
	}
	else
	{
		return $rets[0];
	}
}

1;
