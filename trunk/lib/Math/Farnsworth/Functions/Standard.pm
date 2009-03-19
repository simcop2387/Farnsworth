package Math::Farnsworth::Functions::Standard;

use strict;
use warnings;

use Math::Farnsworth::Value;
use utf8;

use Data::Dumper;

use Math::Pari;

sub init
{
   my $env = shift;

   #i should really make some stuff to make this easier
   #maybe some subs in Math::Farnsworth::Value that get exported
   my $array = new Math::Farnsworth::Value::Array([]);
   my $string = new Math::Farnsworth::Value::String("");
   my $lambda = new Math::Farnsworth::Value::Lambda();
   my $number = new Math::Farnsworth::Value::Pari(0);

   $env->{funcs}->addfunc("push", [["arr", undef, $array], ["in", undef, "VarArg"]],\&push); #actually i might rewrite this in farnsworth now that it can do it
   $env->{funcs}->addfunc("pop", [["arr", undef, $array]],\&pop); #eventually this maybe too
   $env->{funcs}->addfunc("shift", [["arr", undef, $array]], \&shift);
   $env->{funcs}->addfunc("unshift", [["arr", undef, $array], ["in", undef, "VarArg"]], \&unshift);
   $env->{funcs}->addfunc("sort", [["sortsub", undef, $lambda],["arr", undef, $array]],\&sort);

   $env->{funcs}->addfunc("length", [["in", undef, undef]],\&length);

   $env->{funcs}->addfunc("ord", [["in", undef, $string]],\&ord);
   $env->{funcs}->addfunc("chr", [["in", undef, $number]],\&chr);
   $env->{funcs}->addfunc("index", [["str", undef, $string],["substr", undef, $string],["pos", $number, $number]],\&index);
   $env->{funcs}->addfunc("eval", [["str", undef, $string]],\&eval);

   $env->eval('dbgprint{x isa ...} := {var z; var n = 0; var p; while(n != length[x]) {p = shift[x]; if (p conforms "") {z = p} else {z = "$p"}; _dbgprint[z]}}');
   $env->{funcs}->addfunc("_dbgprint", [["str", undef, $string]], \&dbgprint);
   
   $env->eval('map{sub isa {`x`}, x isa ...} := {if (length[x] == 1 && x@0$ conforms []) {x = x@0$}; if (length[x] == 1 && !(x conforms [])) {x = [x]}; var z=x; var e; var out=[]; while(length[z]) {e = shift[z]; dbgprint[e]; push[out,e => sub]}; dbgprint[out]; out}');

   $env->{funcs}->addfunc("substrLen", [["str", undef, $string],["left", undef, $number],["length", undef, $number]],\&substrlen); #this one works like perls
   $env->eval("substr{str,left,right}:={substrLen[str,left,right-left]}");
   $env->eval("left{str,pos}:={substrLen[str,0,pos]}");
   $env->eval("right{str,pos}:={substrLen[str,length[str]-pos,pos]}");

   $env->{funcs}->addfunc("reverse", [["in", undef, undef]],\&reverse);

   $env->eval("now{} := {#today#}");

   $env->{funcs}->addfunc("unit", [["in", undef, undef]], \&unit);

   $env->eval('max{x isa ...} := {if (length[x] == 1 && x@0$ conforms []) {x = x@0$}; var z=[x]; var m = pop[z]; var n = length[z]; var q; while((n=n-1)>=0){q=pop[z]; q>m?m=q:0}; m}'); 
   $env->eval('min{x isa ...} := {if (length[x] == 1 && x@0$ conforms []) {x = x@0$}; var z=[x]; var m = pop[z]; var n = length[z]; var q; while((n=n-1)>=0){q=pop[z]; q<m?m=q:0}; m}'); 
}

open(my $log, ">>", "/var/www/farnsworth/htdocs/test/debuglog.log");
$log->autoflush(1);

sub dbgprint
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("str"); #i should clean this up more too
    my $string = $input->getstring();

	print "DEBUGLOG: $string\n";
	print $log "$string\n";

	return Math::Farnsworth::Value::Pari->new(1);
}

sub unit
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	#print Dumper($branches);

	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{units}->isunit($branches->[1][0][0])))
	{
		die "First argument to unit[] must be a unit name";
	}

	my $unitvar = $eval->{units}->getunit($branches->[1][0][0]);

	return $unitvar; #if its undef, its undef! i should really make some kind of error checking here
}

sub sort
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;

	my $argcount = $args->getarray();

	my $sortlambda;

	if (ref($args->getarrayref()->[0]) eq "Math::Farnsworth::Value::Lambda")
	{
		$sortlambda = shift(@{$args->getarrayref});
	}
	else
	{
		#i should really do this outside the sub ONCE, but i'm lazy for now
		$sortlambda = $eval->eval("{|a,b| a <=> b}");
	}

	my $sortsub = sub
	{
		my $val = $eval->evalbranch(bless [(bless [$a, $b], 'Array'), $sortlambda], 'LambdaCall');
		
		0+$val->toperl(); #return this, just to make sure the value is right
	};

	my @sorts;

	if ($args->getarray() > 1)
	{
		#we've been given a bunch of things, assume we need to sort them like that
		push @sorts, $args->getarray();
	}
	elsif (($args->getarray() == 1) && (ref($args->getarrayref()->[0]) eq "Math::Farnsworth::Value::Array"))
	{
		#given an array as a second value, dereference it since its the only thing we've got
		push @sorts, $args->getarrayref()->[0]->getarray();
	}
	else
	{
		#ok you want me to sort ONE thing? i'll sort that one thing, in O(1) time!
		return $args->getarrayref()->[0];
	}

	my @rets = CORE::sort $sortsub @sorts;

	#print "SORT RETURNING!\n";
	#print Dumper(\@rets);

	return new Math::Farnsworth::Value::Array([@rets]);
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

	unless (ref($arrayvar) eq "Math::Farnsworth::Value::Array")
	{
		die "First argument to push must be an array";
	}

	#ok type checking is done, do the push!
	
	my @input = $args->getarray();
	shift @input; #remove the original array value

	#i should probably flatten arrays here so that; a=[1,2,3]; push[a,a]; will result in a = [1,2,3,1,2,3]; instead of a = [1,2,3,[1,2,3]];

	CORE::push @{$arrayvar->getarrayref()}, @input;

	return new Math::Farnsworth::Value::Pari(0+@input); #returns number of items pushed
}

sub unshift
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[1][0][0])))
	{
		die "First argument to push must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[1][0][0]);

	unless (ref($arrayvar) eq "Math::Farnsworth::Value::Array")
	{
		die "First argument to push must be an array";
	}

	#ok type checking is done, do the push!
	
	my @input = $args->getarray();
	shift @input; #remove the original array value

	#i should probably flatten arrays here so that; a=[1,2,3]; push[a,a]; will result in a = [1,2,3,1,2,3]; instead of a = [1,2,3,[1,2,3]];

	CORE::unshift @{$arrayvar->getarrayref()}, @input;

	return new Math::Farnsworth::Value::Pari(0+@input); 
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

	unless (ref($arrayvar) eq "Math::Farnsworth::Value::Array")
	{
		die "Argument to pop must be an array";
	}

	#ok type checking is done, do the pop
	
	my $retval = CORE::pop @{$arrayvar->getarrayref()};

	return $retval; #pop returns the value of the element removed
}

sub shift
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[1][0][0])))
	{
		die "Argument to pop must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[1][0][0]);

	unless (ref($arrayvar) eq "Math::Farnsworth::Value::Array")
	{
		die "Argument to pop must be an array";
	}

	#ok type checking is done, do the pop
	
	my $retval = CORE::shift @{$arrayvar->getarrayref()};

	return $retval; #pop returns the value of the element removed
}

sub length
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = $args->getarray();

	my @rets;

	for my $arg (@argsarry)
	{
		if (ref($arg) eq "Math::Farnsworth::Value::Array")
		{
			CORE::push @rets, Math::Farnsworth::Value::Pari->new(scalar $arg->getarray());
		}
		elsif (ref($arg) eq "Math::Farnsworth::Value::String")
		{
			CORE::push @rets, Math::Farnsworth::Value::Pari->new(length $arg->getstring());
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value::Pari->new(0);
		}
	}

	if (@rets > 1)
	{
		return Math::Farnsworth::Value::Array->new(\@rets);
	}
	else
	{
		return $rets[0];
	}
}

sub reverse
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = $args->getarray();

	my @rets;

	for my $arg (reverse @argsarry) #this will make reverse[1,2,3,4] return [4,3,2,1]
	{
		if (ref($arg) eq "Math::Farnsworth::Value::Array")
		{
			CORE::push @rets, Math::Farnsworth::Value::Array->new([reverse $arg->getarray()]);
		}
		elsif (ref($arg) eq "Math::Farnsworth::Value::String")
		{
			CORE::push @rets, Math::Farnsworth::Value::String->new("".reverse($arg->getstring()));
		}
		else
		{
			CORE::push @rets, $arg; #should i make it print the reverse of all its arguments? yes, lets fix that
		}
	}

	if (@rets > 1)
	{
		return Math::Farnsworth::Value::Array->new(\@rets);
	}
	else
	{
		return $rets[0];
	}
}

sub substrlen
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = $args->getarray();

	if (ref $arg[0] eq "Math::Farnsworth::Value::String")
	{
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = substr($arg[0]->getstring(), $arg[1]->toperl(), $arg[2]->toperl());
		#print "SUBSTR :: $ns\n";
		return Math::Farnsworth::Value::String->new($ns);
	}
	else
	{
		die "substr and friends only works on strings";
	}
}

sub ord
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = $args->getarray();

	if (ref $arg[0] eq "Math::Farnsworth::String")
	{
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = ord($arg[0]->getstring()); #substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		#print "ord :: $ns\n";
		return Math::Farnsworth::Value::Pari->new($ns);
	}
	else
	{
		die "ord[] only works on strings";
	}
}

sub chr
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = $args->getarray();

	if ($arg[0]->conforms($arg[0]->TYPE_PLAIN))
	{
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = chr($arg[0]{pari}); #substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		#print "chr :: $ns\n";
		return Math::Farnsworth::Value::String->new($ns); #give string flag of 1, since we don't know what language is intended
	}
	else
	{
		die "chr[] only works on plain numbers";
	}
}

sub index
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = $args->getarray();

	if (ref($arg[0]) eq "Math::Farnsworth::Value::String" && ref($arg[1]) eq "Math::Farnsworth::Value::String")
	{
		my $pos = 0;
		if (defined($arg[2]) && $arg[2]->conforms($arg[2]->TYPE_PLAIN))
		{
			$pos = $arg[2]->toperl();
		}
		my $string = $arg[0]->getstring();
		my $substr = $arg[1]->getstring();
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = index $string, $substr, $pos; #substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		return Math::Farnsworth::Value::Pari->new($ns); #give string flag of 1, since we don't know what language is intended
	}
	else
	{
		die "arguments to index[] are of the incorrect type";
	}
}

sub eval
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = $args->getarray();

	if (ref($arg[0]) eq "Math::Farnsworth::Value::String")
	{
		my $nvars = new Math::Farnsworth::Variables($eval->{vars});
		my %nopts = (vars => $nvars, funcs => $eval->{funcs}, units => $eval->{units}, parser => $eval->{parser});
	    my $neval = $eval->new(%nopts);

		return $neval->eval($arg[0]->getstring());
	}
	else
	{
		die "eval[] only works on strings";
	}
}

1;
