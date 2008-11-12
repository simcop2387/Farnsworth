package Math::Farnsworth::Output;

use strict;
use warnings;

use overload '""' => \&tostring;

use Data::Dumper;
use Date::Manip;

our %combos;
our %displays;

#these primarily are used for display purposes
sub addcombo
{
	my $name = shift;
	my $value = shift; #this is a valueless list of dimensions

	print "ADDING COMBO!\n";
	print Dumper($name, $value);
	$combos{$name} = $value;
}

#this returns the name of the combo that matches the current dimensions of a Math::Farnsworth::Value
sub findcombo
{
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
	my $name = shift; #this only works on things created by =!= or |||, i might try to extend that later but i don't think i need to, since you can just create a name with ||| when you need it
	my $branch = shift;

	
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
  die "Forgot to add \$eval to params!" unless ref($self->{eval} eq "Math::Farnsworth::Evaluate");

  bless $self;
}

sub tostring
{
  my $self = shift;
  my $value = $self->{obj};
  my $dimen = $self->{obj}{dimen};

  return $self->getdisplay($dimen, $value);
}

#this takes a set of dimensions and returns what to display
sub getdisplay
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
			return $self->getdisplay($number->{dimen}, $number) . " ".$string->{pari};
		}
		elsif (exists($value->{outmagic}[0]) && (!exists($value->{outmagic}[0]{dimen}{dimen}{array})))
		{
			#ok we were given a value without the string
			my $number = $value->{outmagic}[0];
			return $self->getdisplay($number->{dimen}, $number);
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
			push @array, $self->getdisplay($v->{dimen}, $v);
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
	else
	{
		#added a sort so its stable, i'll need this...
		for my $d (sort {$a cmp $b} keys %{$dimen->{dimen}})
		{
			my $exp = "";
			#print Dumper($dimen->{dimen}, $exp);
			$exp = "^".($dimen->{dimen}{$d} =~ /^[\d\.]+$/? $dimen->{dimen}{$d} :"(".$dimen->{dimen}{$d}.")") unless ($dimen->{dimen}{$d} == 1);
			
			
			push @returns, $self->{units}->getdimen($d).$exp;
		}
		
		if (my $combo = Math::Farnsworth::Output::findcombo($value)) #this should be a method?
		{
			push @returns, "/* $combo */";
		}


		my $prec = Math::Pari::setprecision();
		Math::Pari::setprecision(15); #set it to 15?
		my $pv = "".(Math::Pari::pari_print($value->{pari}));
		if ($pv =~ m|/|) #check for rationality
		{
			my $nv = "".($value->{pari} * 1.0); #attempt to force a floating value
			$nv =~ s/([.]\d+?)0+$/$1/ ;
			$pv .= "  /* apx ($nv) */";
		}

		$pv = ($pv =~ /^[\d\.]+$/? $pv :"(".$pv.")"); #check if its a simple value, or complex, if it is complex, add parens
		$pv =~ s/([.]\d+?)0+$/$1/ ;
		Math::Pari::setprecision($prec); #restore it before calcs
		return $pv." ".join " ", @returns;
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
