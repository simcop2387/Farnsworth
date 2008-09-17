#!/usr/bin/perl

package Math::Farnsworth::Value;

use strict;
use warnings;

use Math::Pari;

our $VERSION = 0.5;

use overload 
    '+' => \&add,
    '-' => \&subtract,
    '*' => \&mult,
    '/' => \&div;

sub new
{
  my $class = shift;
  my $value = shift;
  my $dimen = shift; #should only really be used internally?

  my $self = {};

  bless $self, $class;

  $self->{pari} = PARI $value;
  $self->{dimen} = $dimen;

  return $self;
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
       $z = 0 if (!exists($target->{dimen}{$k});
       $v = 0 if ($self->{targe}{$k} != $target->{dimen}{$k});
     }

     if ($z && $v)
     {
        return 1;
     }
  }

  return 0;
}

sub toperl
{
  my $self = shift;
  return "".($self->{pari}); #stringifiying it seems to work
}

sub add
{
  my ($one, $two, $rev) = @_;
  my $new = new Math::Farnsworth::Value($one->{pari} + $two->{pari});

  #i also need to check the units, but that will come later

  return $new;
}

sub subtract
{
}

sub mult
{
}

sub div
{
}
