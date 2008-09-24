package Math::Farnsworth::Dimension;

use strict;
use warnings;

use Data::Dumper;

use List::MoreUtils qw(uniq);

sub new
{
	my $class = shift;
	my $dims;
	if (@_ > 1) #if we've got more than one, they didn't use a hashref
	{
		$dims = +{@_}; #throw it into a hashref
	}
	else
	{
		if (@_)
		{
			$dims = +{%{$_[0]}}; #make a shallow copy, i don't feel like debugging this later if somehow i ended up with two objects blessing the same hashref
		}
		else
		{
			#none, use empty hash
			$dims = {};
		}
	}

	my $self = {dimen =>$dims}; #so i don't have to rewrite a lot of code... NTS: this should probably go away later

	bless $self;
}

sub compare
{
  my $self = shift;
  my $target = shift;

  if ((!ref($target)) && keys %{$self->{dimen}} == 0)
  {
	  return 1;
  }

  if (keys %{$target->{dimen}} == keys %{$self->{dimen}}) #check lengths of keys
  {
     my $z = 1;
     my $v = 1;
     for my $k (keys %{$self->{dimen}})
     {
       $z = 0 if (!exists($target->{dimen}{$k}));
       $v = 0 if ($self->{dimen}{$k} != $target->{dimen}{$k});
     }

     if ($z && $v) #also check if there are no dimensions
     {
        return 1;
     }
  }

  return 0;
}

sub invert
{
	my $self = shift;
	#i CAN'T modify myself in this!
	my $atom = $self->new($self->{dimen});

	for (keys %{$atom->{dimen}})
	{
		#turn all positives to negatives and vice versa
		$atom->{dimen}{$_} = -$atom->{dimen}{$_};
	}

	return $atom->prune();
}

sub merge
{
	my $self = shift;
	#i CAN'T modify myself in this!
	my $atom = Math::Farnsworth::Dimension->new($self->{dimen});
	
	my $partner = shift;
	my $pd = {};

	if (ref($partner) eq "Math::Farnsworth::Dimension")
	{
		$pd = $partner->{dimen};
	}

    for (uniq (keys %{$atom->{dimen}}, keys %{$pd}))
	{
		no warnings 'uninitialized';
		$atom->{dimen}{$_} += $partner->{dimen}{$_};
	}

	return $atom->prune();
}

sub mult
{
	my $self = shift;
	#i CAN'T modify myself in this!
	my $atom = Math::Farnsworth::Dimension->new($self->{dimen});
	
	my $value = shift;

	for (keys %{$atom->{dimen}})
	{
		no warnings 'uninitialized';
		$atom->{dimen}{$_} *= $value; #this might turn them into Math::PARI objects? does it matter?
	}

	return $atom->prune();
}


sub prune
{
	my $self = shift;
	
	for (keys %{$self->{dimen}})
	{
		if (!$self->{dimen}{$_})
		{
			delete $self->{dimen}{$_};
		}
	}

	return $self;
}

1;

# vim: filetype=perl
