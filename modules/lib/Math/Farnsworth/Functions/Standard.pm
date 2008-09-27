package Math::Farnsworth::Functions::Standard;

use strict;
use warnings;

use Math::Pari;

sub init
{
   my $env = shift;

   $env->{funcs}->addfunc("push", [],\&push);
   $env->{funcs}->addfunc("pop", [],\&pop);
   $env->{funcs}->addfunc("length", [],\&length);
   $env->{funcs}->addfunc("substr", [],\&substr);
   $env->{funcs}->addfunc("substrLen", [],\&substrlen);
   $env->{funcs}->addfunc("left", [],\&left);
   $env->{funcs}->addfunc("right", [],\&right);
   $env->{funcs}->addfunc("reverse", [],\&reverse);
}

sub push
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[0][0])))
	{
		die "Argument to push must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[0][0]);

	if (!exists($arrayvar->{dimen}{dimen}{array}))
	{
		die "Argument to push must be an array";
	}

	#ok type checking is done, do the push!
	
	my @input = @{$args->{pari}};
	shift @input; #remove the original array value

	#i should probably flatten arrays here so that; a=[1,2,3]; push[a,a]; will result in a = [1,2,3,1,2,3]; instead of a = [1,2,3,[1,2,3]];

	push @{$arrayvar->{pari}}, @input;

	return undef; #push doesn't return anything? probably should, but i'll do that later
}

sub pop
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[0][0])))
	{
		die "Argument to pop must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[0][0]);

	if (!exists($arrayvar->{dimen}{dimen}{array}))
	{
		die "Argument to pop must be an array";
	}

	#ok type checking is done, do the pop
	
	my $retval = pop @{$arrayvar->{pari}};

	return $retval; #pop returns the value of the element removed
}
