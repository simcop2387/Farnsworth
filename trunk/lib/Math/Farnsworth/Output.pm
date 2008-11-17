package Math::Farnsworth::Output;

use strict;
use warnings;

use overload '""' => \&tostring;

use Data::Dumper;
use Date::Manip;
use Carp;

our %combos;
our %displays;

#these primarily are used for display purposes
sub addcombo
{
	my $name = shift;
	my $value = shift; #this is a valueless list of dimensions

	$combos{$name} = $value;
}

#this returns the name of the combo that matches the current dimensions of a Math::Farnsworth::Value
sub findcombo
{
	my $self = shift;
	my $value = shift;

	for my $combo (keys %combos)
	{
		my $cv = $combos{$combo}; #grab the value
		return $combo if ($value->{dimen}->compare($cv->{dimen}));
	}

	return undef; #none found
}

#this sets a display for a combo first, then for a dimension
sub setdisplay
{
	my $self = shift;
	my $name = shift; #this only works on things created by =!= or |||, i might try to extend that later but i don't think i need to, since you can just create a name with ||| when you need it
	my $branch = shift;

	#I SHOULD CHECK FOR THE NAME!!!!!
	#print Dumper($name, $branch);

	if (exists($combos{$name}))
	{
		$displays{$name} = $branch;
	}
	else
	{
		die "No such dimension/combination as $name\n";
	}
}

sub getdisplay
{
	my $self = shift;
	my $name = shift;

	if (exists($displays{$name}))
	{
		return $displays{$name}; #guess i'll just do the rest in there?
	}

	return undef;
}

sub new
{
  shift; #remove the class
  my $self = {};
  $self->{units} = shift;
  $self->{obj} = shift;
  $self->{eval} = shift;

  #warn Dumper($self->{obj});
  die "Attempting to make output class of non Math::Farnsworth::Value" unless ref($self->{obj}) eq "Math::Farnsworth::Value";
  confess "Forgot to add \$eval to params!" unless ref($self->{eval}) eq "Math::Farnsworth::Evaluate";

  bless $self;
}

sub tostring
{
  my $self = shift;
  my $value = $self->{obj};
  my $dimen = $self->{obj}{dimen};

  return $self->getstring($dimen, $value);
}

#this takes a set of dimensions and returns what to display
sub getstring
{
	my $self = shift; #i'll implement this later too
	my $dimen = shift; #i take a Math::Farnsworth::Dimension object!
    my $value = shift; #the value so we can stringify it

    my @returns;

	if (defined($value->{outmagic}))
	{
		if (exists($value->{outmagic}[1]{dimen}{dimen}{string}))
		{
			#ok we were given a string!
			my $number = $value->{outmagic}[0];
			my $string = $value->{outmagic}[1];
			return $self->getstring($number->{dimen}, $number) . " ".$string->{pari};
		}
		elsif (exists($value->{outmagic}[0]) && (!exists($value->{outmagic}[0]{dimen}{dimen}{array})))
		{
			#ok we were given a value without the string
			my $number = $value->{outmagic}[0];
			return $self->getstring($number->{dimen}, $number);
		}
		else
		{
			die "Unhandled output magic, this IS A BUG!";
		}
	}
	elsif (exists($dimen->{dimen}{"bool"}))
	{
		return $value ? "True" : "False"
		#these should do something!
	}
	elsif (exists($dimen->{dimen}{"string"}))
	{
		#I NEED FUNCTIONS TO HANDLE ESCAPING AND UNESCAPING!!!!
		my $val = $value->{pari};
		$val =~ s/\\/\\\\/g; 
		$val =~ s/"/\\"/g;
		return '"'.$val.'"';
	}
	elsif (exists($dimen->{dimen}{"array"}))
	{
		my @array; #this will be used to build the output
		for my $v (@{$value->{pari}})
		{
			#print Dumper($v);
			push @array, $self->getstring($v->{dimen}, $v);
		}

		return '['.(join ' , ', @array).']';
	}
	elsif (exists($dimen->{dimen}{"date"}))
	{
		return UnixDate($value->{pari}, "# %C #"); #output in ISO format for now
	}
	elsif (exists($dimen->{dimen}{"lambda"}))
	{
		return "No magic for lambdas yet, functions shall get this too";
	}
	elsif (exists($dimen->{dimen}{"undef"}))
	{
		return "undef";
	}
	elsif (ref($value) eq "HASH")
	{
		warn "RED ALERT!!!! WE've got a BAD CASE HERE. We've got an UNBLESSED HASH";
		warn Dumper($value);

		return "undef";
	}
	elsif (my $disp = $self->getdisplay($self->findcombo($value)))
	{
		#$disp should now contain the branches to be used on the RIGHT side of the ->
		#wtf do i put on the left? i'm going to send over the Math::Farnsworth::Value, this generates a warning but i can remove that after i decide that its correct

		print "SUPERDISPLAY:\n";
		my $branch = bless [$value, $disp], 'Trans';
		print Dumper($branch);
		my $newvalue = $self->{eval}->evalbranch($branch); #recurse down!
		return $self->getstring($newvalue->{dimen}, $newvalue);
	}
	else
	{
		#added a sort so its stable, i'll need this...
		for my $d (sort {$a cmp $b} keys %{$dimen->{dimen}})
		{
			my $exp = "";
			#print Dumper($dimen->{dimen}, $exp);
			my $dv = "".$dimen->{dimen}{$d};

			$dv =~ s/([.]\d+?)0+$/$1/;
			$dv =~ s/E/e/; #make floating points clearer

			$exp = "^".($dv =~ /^[\d\.]+$/? $dv :"(".$dv.")") unless ($dv == 1);
			
			push @returns, $self->{units}->getdimen($d).$exp;
		}
		
		if (my $combo = $self->findcombo($value)) #this should be a method?
		{
			push @returns, "/* $combo */";
		}


		my $prec = Math::Pari::setprecision();
		Math::Pari::setprecision(15); #set it to 15?
		my $pv = "".(Math::Pari::pari_print($value->{pari}));
		my $parenflag = $pv =~ /^[\d\.e]+$/i;
		my $rational = $pv =~ m|/|;

		$pv =~ s/E/e/; #make floating points clearer

		if ($pv =~ m|/|) #check for rationality
		{
			my $nv = "".Math::Pari::pari_print($value->{pari} * 1.0); #attempt to force a floating value
			$nv =~ s/([.]\d+?)0+$/$1/ ;
			$pv .= "  /* apx ($nv) */";
		}

		$pv = ($parenflag? $pv :"(".$pv.")"); #check if its a simple value, or complex, if it is complex, add parens
		$pv =~ s/([.]\d+?)0+$/$1/ ;

		Math::Pari::setprecision($prec); #restore it before calcs
		return $pv." ".join " ", @returns;
	}
}

sub deparsetree
{
	my $self = shift;
	my $branch = shift;

	my $type = ref($branch);
	
	if ($type eq "Add")
	{
		my $a = $self->deparsetree($branch->[0]);
		my $b = $self->deparsetree($branch->[1]);
		return $a . " + " . $b;
	}
	elsif ($type eq "Sub")
	{
		my $a = $self->deparsetree($branch->[0]);
		my $b = $self->deparsetree($branch->[1]);
		return $a . " - " . $b;
	}
	elsif ($type eq "Mul")
	{
		my $a = $self->deparsetree($branch->[0]);
		my $b = $self->deparsetree($branch->[1]);
		my $t = $branch->[2];

		return $a . ' * ' . $b; #NOTE: this should listen to the 'imp' or '*' in the tree!
	}
	elsif ($type eq "Div")
	{
		my $a = $self->deparsetree($branch->[0]);
		my $b = $self->deparsetree($branch->[1]);
		my $t = $branch->[2];

		$return = $a . " $t " . $b;
	}
	elsif ($type eq "Conforms")
	{
		my $a = $self->deparsetree($branch->[0]);
		my $b = $self->deparsetree($branch->[1]);
		return "$a conforms $b";
	}
	elsif ($type eq "Mod")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a % $b";
	}
	elsif ($type eq "Pow")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a ^ $b";
	}
	elsif ($type eq "And")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);

		return "$a && $b";
	}
	elsif ($type eq "Or")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		
		return "$a || $b";
	}
	elsif ($type eq "Xor")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a ^^ $b";
	}
	elsif ($type eq "Not")
	{
		my $a = $self->makevalue($branch->[0]);
		return "!$a";
	}
	elsif ($type eq "Gt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a > $b";
	}
	elsif ($type eq "Lt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a < $b";
	}
	elsif ($type eq "Ge")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a >= $b";
	}
	elsif ($type eq "Le")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a <= $b";
	}
	elsif ($type eq "Compare")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a <=> $b";
	}
	elsif ($type eq "Eq")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a == $b";
	}
	elsif ($type eq "Ne")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		return "$a != $b";
	}
	elsif ($type eq "Ternary")
	{
		my $left = $self->makevalue($branch->[0]);
		my $one = $self->deparsetree($branch->[1]);
		my $two = $self->deparsetree($branch->[2]);

		return "$left ? $one : $two";
	}
	elsif ($type eq "If")
	{
		my $return = "";
		my $left = $self->makevalue($branch->[0]);
        my $std = $self->deparsetree($branch->[1]);
		
		$return = "if ($left) { $std }";

		if ($branch->[2])
		{
			$return .= "else { $else }";
		}
		
		#$return .= ";"; #NOTE: DO I NEED THIS? probably not!

		return $return;
	}
	elsif ($type eq "Store")
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);

		return "$name = $value";
	}
	elsif ($type eq "DeclareVar")
	{
		my $name = $branch->[0];

		my $return = "var $name";

		if (defined($branch->[1]))
		{
			my $val =  $self->makevalue($branch->[1]);
			$return .= " = $val";
		}

		return $return;
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
				#print Dumper($constraint);
				$constraint = $self->makevalue($constraint); #should be right
				#print Dumper($constraint);
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

		#print "==========LAMBDA==========\n";
		#print Data::Dumper->Dump([$args,$code], ["args", "code"]);

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
				#print Dumper($constraint);
				$constraint = $self->makevalue($constraint); #should be right
				#print Dumper($constraint);
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

		die "Right side of lamdbda call must evaluate to a Lambda\n" unless $right->{dimen}{dimen}{lambda};

		#need $args to be an array
		my $args = $left->{dimen}{dimen}{array} ? $left :  new Math::Farnsworth::Value([$left], {array => 1}); 

		$return = $self->{funcs}->calllambda($right, $args);
	}
	elsif (($type eq "Array") || ($type eq "SubArray"))
	{
		my $array = []; #fixes bug with empty arrays
		for my $bs (@$branch) #iterate over all the elements
		{
			my $type = ref($bs); #find out what kind of thing we are
			my $value = $self->makevalue($bs);

			#print "ARRAY FILL -- $type\n";

			if (exists($value->{dimen}{dimen}{array}))
			{
				#since we have an array, but its not in a SUBarray, we dereference it before the push
				push @$array, @{$value->{pari}} unless ($type eq "SubArray");
				push @$array, $value if ($type eq "SubArray");
			}
			else
			{
				#print "ARRAY VALUE --- ".Dumper($value);
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
		print Dumper($branch);
		my $combo = $branch->[0][0]; #is a string?
		my $right = $branch->[1];

		Math::Farnsworth::Output->setdisplay($combo, $right);
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
	elsif ($type eq "DefineCombo")
	{
		my $combo = $branch->[1]; #should get me a string!
		my $value = $self->makevalue($branch->[0]);
		Math::Farnsworth::Output::addcombo($combo, $value);
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
	else
	{
		return Dumper($tree);
	}
}

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Math::Farnsworth::Output - Wrapper class for making output simpler

=head1 SYNOPSIS

  use Math::Farnsworth;
  
  my $hubert = Math::Farnsworth->new();

  my $result = $hubert->runString("10 km -> miles");

  my $result = $hubert->runFile("file.frns");

  print $result;

=head1 METHODS

This has only one method that a user should be aware of, C<tostring>; you can call this directly on the object, e.g. $result->tostring() 

=head1 AUTHOR

Ryan Voots E<lt>simcop@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Ryan Voots

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
