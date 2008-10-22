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

use Date::Manip;

use Math::Pari ':hex'; #why not?

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

	#print Dumper($tree);

    $self->evalbranch($tree);
}

#evaluate a single branch
sub evalbranch
{
	my $self = shift;

	my $branch = shift;
	my $type = ref($branch); #this'll grab what kind from the bless on the tree

	my $return; #to make things simpler later on
	my $outdim; #this'll change names probably, but will go along with $return to provide some nicer info for printing

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
	elsif ($type eq "Conforms")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = new Math::Farnsworth::Value($a->{dimen}->compare($b->{dimen}), {bool => 1});
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
	elsif ($type eq "And")
	{
		my $a = $self->makevalue($branch->[0]);

		if ($a->bool())
		{
			my $b = $self->makevalue($branch->[1]);
			$return = $a && $b ? 1 : 0;
			$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
		}
		else
		{
			$return = Math::Farnsworth::Value->new(0, {bool=>1}); #make sure its the right type
		}
	}
	elsif ($type eq "Or")
	{
		my $a = $self->makevalue($branch->[0]);

		if ($a->bool())
		{
			$return = Math::Farnsworth::Value->new(1, {bool=>1}); #make sure its the right type
		}
		else
		{
			my $b = $self->makevalue($branch->[1]);
			$return = $a || $b ? 1 : 0;
			$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
		}
	}
	elsif ($type eq "Xor")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a->bool() ^ $b->bool() ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Not")
	{
		my $a = $self->makevalue($branch->[0]);
		$return = $a->bool() ? 0 : 1;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Gt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = ($a > $b) ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Lt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a < $b ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Ge")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a >= $b ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Le")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a <= $b ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Compare")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a <=> $b;
		#$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Eq")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a == $b ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Ne")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a != $b ? 1 : 0;
		$return = Math::Farnsworth::Value->new($return, {bool=>1}); #make sure its the right type
	}
	elsif ($type eq "Ternary")
	{
		#turing completeness FTW
		#wtf? for some reason i have to do this...
		#odd bug here, + 0 fixes?
		my $left = $self->makevalue($branch->[0]);
		$left = $left != new Math::Farnsworth::Value(0, $left->{dimen});
		$return = $left ? $self->makevalue($branch->[1]) : $self->makevalue($branch->[2]);
	}
	elsif ($type eq "If")
	{
		#turing completeness FTW
		#wtf? for some reason i have to do this...
		#odd bug here, + 0 fixes?
		my $left = $self->makevalue($branch->[0]);
		$left = $left != new Math::Farnsworth::Value(0, $left->{dimen});
		
		if ($left)
		{
			$return = $self->makevalue($branch->[1]);
		}
		else
		{
			$return = $self->makevalue($branch->[2]);
		}
	}
	elsif ($type eq "Store")
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);
		$return = $value; #make stores evaluate to the value on the right
		$self->{vars}->setvar($name, $value);
	}
	elsif ($type eq "DeclareVar")
	{
		my $name = $branch->[0];
		my $value;

		if (defined($branch->[1]))
		{
			$value = $self->makevalue($branch->[1]);
		}
		else
		{
			$value = $self->makevalue(bless [0], 'Num');
		}

		$return = $value; #make stores evaluate to the value on the right
		$self->{vars}->declare($name, $value);
	}
	elsif ($type eq "FuncDef")
	{
		#print Dumper($branch);
		my $name = $branch->[0];
		my $args = $branch->[1];
		my $value = $branch->[2]; #not really a value, but in fact the tree to run for the function

		my $vargs;

		for my $arg (@$args)
		{
			my $constraint = $arg->[2];
			my $default = $arg->[1];
			my $name = $arg->[0]; #name

			if (defined($default))
			{
				$default = $self->makevalue($default); #should be right
			}

			if (defined($constraint))
			{
				print Dumper($constraint);
				$constraint = $self->makevalue($constraint); #should be right
				print Dumper($constraint);
			}

			push @$vargs, [$name, $default, $constraint];
		}

		$self->{funcs}->addfunc($name, $vargs, $value);
		$return = undef; #cause an error should someone manage to make it parse other than the way i think it should be
	}
	elsif ($type eq "FuncCall")
	{
		my $name = $branch->[0];
		my $args = $self->makevalue($branch->[1]); #this is an array, need to evaluate it

		$return = $self->{funcs}->callfunc($self, $name, $args, $branch);

		#print "FUNCCALL RETURNED\n";
		#print Dumper($return);

	}
	elsif ($type eq "Lambda")
	{
		my $args = $branch->[0];
		my $code = $branch->[1];

		print "==========LAMBDA==========\n";
		print Data::Dumper->Dump([$args,$code], ["args", "code"]);

		my $nvars = new Math::Farnsworth::Variables($self->{vars}); #lamdbas get their own vars
		my %nopts = (vars => $nvars, funcs => $self->{funcs}, units => $self->{units}, parser => $self->{parser});
		my $scope = $self->new(%nopts);

		#this should probably get a function in Math::Farnsworth::FunctionDispatch
		my $vargs;

		for my $arg (@$args)
		{
			my $constraint = $arg->[2];
			my $default = $arg->[1];
			my $name = $arg->[0]; #name

			if (defined($default))
			{
				$default = $self->makevalue($default); #should be right
			}

			if (defined($constraint))
			{
				print Dumper($constraint);
				$constraint = $self->makevalue($constraint); #should be right
				print Dumper($constraint);
			}

			push @$vargs, [$name, $default, $constraint];
		}

		my $lambda = {code => $code, args => $vargs, 
			          scope => $scope};

		$return = new Math::Farnsworth::Value($lambda, {lambda => 1});
	}
	elsif ($type eq "LambdaCall")
	{		
		my $left = $self->makevalue($branch->[0]);
		my $right = $self->makevalue($branch->[1]);

		#print Dumper($right);

		die "Right side of lamdbda call must evaluate to a Lambda\n" unless $right->{dimen}{dimen}{lambda};

		#theres a lot of duplicate code here from function calls, maybe merging them somehow sooner or later is a good idea
		#my $scope = $right->{pari}{scope};
		#my $code = $right->{pari}{code};
		#my $argtypes = $right->{pari}{args};
		
		#need $args to LOOK like an array just to make things easier
		my $args = $left->{dimen}{dimen}{array} ? $left :  new Math::Farnsworth::Value([$left], {array => 1}); 

		#for my $argc (0..$#$argtypes)
		#{
		#		my $n = $argtypes->[$argc][0]; #the rest are defaults and constraints
		#	my $v = $args->{pari}->[$argc];
		#
		#	print "Declaring $n to be " . $v->toperl($self->{units}) . "\n";

		#	$scope->{vars}->declare($n, $v);
		#}

		$return = $self->{funcs}->calllambda($right, $args);
	}
	elsif (($type eq "Array") || ($type eq "SubArray"))
	{
		my $array = []; #fixes bug with empty arrays
		for my $bs (@$branch) #iterate over all the elements
		{
			my $type = ref($bs); #find out what kind of thing we are
			my $value = $self->makevalue($bs);

			if (exists($value->{dimen}{dimen}{array}))
			{
				#since we have an array, but its not in a SUBarray, we dereference it before the push
				push @$array, @{$value->{pari}} unless ($type eq "SubArray");
				push @$array, $value if ($type eq "SubArray");
			}
			else
			{
				#its not an array or anything so we push it on
				push @$array, $value; #we return an array ref! i need more error checking around for this later
			}
		}
		$return = new Math::Farnsworth::Value($array, {array => 1});
	}
	elsif ($type eq "ArgArray")
	{
		my $array;
		for my $bs (@$branch) #iterate over all the elements
		{
			my $type = ref($bs); #find out what kind of thing we are
			my $value = $self->makevalue($bs);

			#even if it is an array we don't want to deref it here, because thats the wrong behavior, this will make things like push[a, 1,2,3] work properly
			push @$array, $value; #we return an array ref! i need more error checking around for this later
		}
		$return = new Math::Farnsworth::Value($array, {array => 1});
	}
	elsif ($type eq "ArrayFetch")
	{
		my $var = $self->makevalue($branch->[0]); #need to check if this is an array, and die if not
		my $listval = $self->makevalue($branch->[1]);
		my @rval;

		#print Dumper($branch, $var, $listval);

		for (@{$listval->{pari}})
		{
			my $input = $var->{pari}->[$_];
			die "Array out of bounds\n" unless defined $input; #NTS: would be useful to look if i have a name and use it
			push @rval, $input;
		}

		#print Dumper(\@rval);

		if (@rval > 1)
		{
			my $pr = $self->makevalue(bless [bless ['0.1234'], 'Num'], 'Array'); #we return an array
			$pr->{pari} = [@rval]; #make a shallow copy, why not
			$return = $pr;
		}
		else
		{
			$return = $rval[0];
		}
	}
	elsif ($type eq "ArrayStore")
	{
		my $var = $self->makevalue(bless [$branch->[0]], 'Fetch'); #need to check if this is an array, and die if not
		my $listval = $self->makevalue($branch->[1]);
		my $rval = $self->makevalue($branch->[2]);

		#print Dumper($branch, $var, $listval);

		if (@{$listval->{pari}} > 1)
		{
			die "Assigning to slices not implemented yet\n";
		}

		$var->{pari}->[${$listval->{pari}}[0]] = $rval;

		for my $value (@{$var->{pari}})
		{
			$value = $self->makevalue(bless [0], 'Num') if !defined($value);
		}

		$return = $rval;
	}
	elsif ($type eq "While")
	{
		my $cond = $branch->[0]; #what to check each time
		my $stmts = $branch->[1]; #what to run each time

		my $condval = $self->makevalue($cond);
		while ($condval)
		{
			my $v = $self->makevalue($stmts);
			$condval = $self->makevalue($cond);
		}

		$return = undef; #cause errors
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
		$outdim = $branch; #have this display back what we saw
	}
	elsif ($type eq "DefineDimen")
	{
		my $unit = $branch->[1];
		my $dimen = $branch->[0];
		$self->{units}->adddimen($dimen, $unit);
		$outdim = $branch;
	}
	elsif (($type eq "SetPrefix") || ($type eq "SetPrefixAbrv"))
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);
		#print "SETTING PREFIX0: $name : $value : ".Dumper($branch->[1]) if ($name eq "m");
		$self->{units}->setprefix($name, $value);
	}
	elsif ($type eq "Trans")
	{
		my $left = $self->makevalue($branch->[0]);
		my $rights = eval {$self->makevalue($branch->[1])};
		my $right = $rights;

		if ($rights->{dimen}{dimen}{string}) #if its a string we do some fun stuff
		{
			$right = $self->eval($rights->{pari}); #we need to set $right to the evaluation $rights
		}

		if (!$@)
		{
			if ($left->{dimen}->compare($right->{dimen})) #only do this if they are the same
			{
				my $dispval = ($left / $right);
				$return = $left;
				
				if ($rights->{dimen}{dimen}{string})
				{
					#right side was a string, use it
					$return->{outmagic} = [$dispval, $rights];
				}
				else
				{
					$return->{outmagic} = [$dispval];
				}
			}
			elsif ($self->{funcs}->isfunc($branch->[1][0]))
			{
				$left = $left->{dimen}{dimen}{array} ? $left : new Math::Farnsworth::Value([$left], {array=>1});
				$return = $self->{funcs}->callfunc($self, $branch->[1][0], $left);
			}
			else
			{
				die "Conformance error, left side has different units than right side\n";
			}
		}
		else
		{
			#$right doesn't evaluate... so we check for a function?
			$left = $left->{dimen}{dimen}{array} ? $left : new Math::Farnsworth::Value([$left], {array=>1});
			$return = $self->{funcs}->callfunc($self, $branch->[1][0], $left);
		}
	}

	if (!defined($outdim))
	{
		#if we don't know any better copy the results
		#$outdim = $return->{dimen}; #this will be magic!
	}
	return $return;
}

sub makevalue
{
	my $self = shift;
	my $input = shift;

#	print "MAKEVALUE---------\n";
#	print Dumper($input);

	if (ref($input) eq "Num")
	{
		#need to make a value here with Math::Farnsworth::Value!
		my $val = new Math::Farnsworth::Value($input->[0]);
		return $val;
	}
	if (ref($input) eq "HexNum")
	{
		#need to make a value here with Math::Farnsworth::Value!
		print "HEX VALUE: ".$input->[0]."\n";
		my $value = eval $input->[0]; #this SHOULD work, shouldn't be a security risk since its validated through the lexer and parser.
		my $val = new Math::Farnsworth::Value($value);
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
			#print "FETCH: $name\n" if ($name eq "milli");
			return $self->{units}->getunit($name);
		}
		
		die "Undefined symbol '$name'\n";
	}
	elsif (ref($input) eq "String") #we've got a string that should be a value!
	{
		my $value = $input->[0];
		#here it comes in with quotes, so lets remove them
		$value =~ s/^"(.*)"$/$1/;
		$value =~ s/\\"/"/g;
		$value =~ s/\\\\/\\/g;
		my $ss = sub{my $var =shift; $var =~ s/^[\$]//; print "MATCHED $var\n";if ($var !~ /^{.*}$/) {$self->{vars}->getvar($var)->toperl($self->{units})} else {$var =~ s/[{}]//g;$self->eval($var)->toperl($self->{units});}};
		$value =~ s/(?<!\\)(\$\w+|\${[^}]+})/$ss->($1)/eg;
		my $val = new Math::Farnsworth::Value($value, {string => 1});
		return $val;
	}
	elsif (ref($input) eq "Date")
	{
		#print "\n\n\nMaking DATE!\n\n\n";
		my $val = new Math::Farnsworth::Value(ParseDate($input->[0]), {date => 1});
#		print Dumper($val);
		return $val;
	}
	elsif (ref($input) eq "VarArg")
	{
		warn "Got a VarArg, code untested, want to mark when i get them\n"; #just so i can track down the inevitable crash
		return "VarArg";
	}
	elsif (ref($input) eq "Math::Farnsworth::Value")
	{
		warn "Got a Math::Farnsworth::Value, i PROBABLY shouldn't be getting these, i'm just going to let it fall through";
		return $input;
	}

	return $self->evalbranch($input);
}

1;
