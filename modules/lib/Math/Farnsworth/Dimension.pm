package Math::Farnsworth::Dimension;

use strict;
use warnings;

use Data::Dumper;

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

	bless $dims, $class;
}

sub comparedimen
{
  my $self = shift;
  my $target = shift;

  if (keys %{$target->{dimen}} == keys %{$target->{dimen}}) #check lengths of keys
  {
     my $z = 1;
     my $v = 1;
     for my $k (keys %{$self->{dimen}})
     {
       $z = 0 if (!exists($target->{dimen}{$k}));
       $v = 0 if ($self->{dimen}{$k} != $target->{dimen}{$k});
     }

     if ($z && $v)
     {
        return 1;
     }
  }

  return 0;
}

1;

# vim: filetype=perl
