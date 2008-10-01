package Math::Farnsworth::Functions::StdMath;

use strict;
use warnings;

use Math::Pari;
use Data::Dumper;

sub init
{
   my $env = shift;

   $env->{funcs}->addfunc("ln", [],\&log);
   $env->{funcs}->addfunc("sin", [],\&sin);
   $env->{funcs}->addfunc("cos", [],\&cos);
   $env->{funcs}->addfunc("tan", [],\&tan);
   $env->eval("csc{x} := {1/sin[x]}"); 
   $env->eval("sec{x} := {1/cos[x]}"); 
   $env->eval("cot{x} := {1/tan[x]}"); 
   $env->eval("log{x} := {ln[x]/ln[10]}"); 
#   $env->{funcs}->addfunc("csc", [],\&csc);
#   $env->{funcs}->addfunc("sec", [],\&sec);
#   $env->{funcs}->addfunc("cot", [],\&cot);
#   $env->{funcs}->addfunc("sinh", [],\&sinh);
#   $env->{funcs}->addfunc("cosh", [],\&cosh);
#   $env->{funcs}->addfunc("tanh", [],\&tanh);
#   $env->{funcs}->addfunc("arcsin", [],\&arcsin);
#   $env->{funcs}->addfunc("arccos", [],\&arccos);
#   $env->{funcs}->addfunc("arctan", [],\&arctan);
#   $env->{funcs}->addfunc("arcsinh", [],\&arcsinh);
#   $env->{funcs}->addfunc("arccosh", [],\&arccosh);
#   $env->{funcs}->addfunc("arctanh", [],\&arctanh);
   $env->{funcs}->addfunc("abs", [],\&abs);
   $env->{funcs}->addfunc("floor", [],\&floor);
   $env->{funcs}->addfunc("ceil", [],\&ceil);
#   $env->{funcs}->addfunc("round", [],\&round); #this will require some more playing to implement properly
   $env->{funcs}->addfunc("int", [],\&int);
   $env->{funcs}->addfunc("trunc", [],\&int);
   $env->{funcs}->addfunc("numerator", [],\&numerator);
   $env->{funcs}->addfunc("denominator", [],\&denominator);
#   $env->{funcs}->addfunc("random", [],\&random);
#   $env->{funcs}->addfunc("randomFloat", [],\&randomFloat);
#   $env->{funcs}->addfunc("randomGaussian", [],\&randomGaussian);

   $env->eval("max{x} := {var z=[x]; var m = pop[z]; var n = length[z]; var q; while((n=n-1)>=0){q=pop[z]; q>m?m=q:0}; m}"); 
   $env->eval("min{x} := {var z=[x]; var m = pop[z]; var n = length[z]; var q; while((n=n-1)>=0){q=pop[z]; q<m?m=q:0}; m}"); 
   #$env->{funcs}->addfunc("min", [],\&min);
   #$env->{funcs}->addfunc("max", [],\&max);
   #these functions are simple enough to implement in farnsworth itself, so why not
   $env->eval("sqrt{x} := {x ^ 0.5}"); 
   $env->eval("exp{x} := {e ^ x}");
   $env->eval("inv{x} := {1/x}"); 
   $env->eval("recip{x} := {1/x}"); 

}

sub sin
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in sin yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The sin of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::sin($arg->{pari}), {});
			print Dumper(\@rets);
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

sub cos
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in cos yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The cos of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::cos($arg->{pari}), {});
			print Dumper(\@rets);
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

sub tan
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::tan($arg->{pari}), {});
			print Dumper(\@rets);
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

sub abs
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in abs yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The abs of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::abs($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub floor
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::floor($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub ceil
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::ceil($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub int
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::truncate($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub numerator
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::numerator($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub denomenator
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::denomenator($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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



















sub log
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::log($arg->{pari}), {});
			print Dumper(\@rets);
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
