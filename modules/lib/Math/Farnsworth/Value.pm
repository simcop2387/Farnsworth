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

  my $self = {};

  bless $self, $class;

  $self->{pari} = PARI $value;

  return $self;
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
