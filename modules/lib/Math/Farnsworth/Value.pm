#!/usr/bin/perl

package Math::Farnsworth::Value;

use strict;
use warnings;

use Math::Pari;
use Math::Farnsworth::Dimension;

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
  
  if (ref($dimen) && $dimen->isa("Math::Farnsworth::Dimension"))
  {
    $self->{dimen} = $dimen;
  }
  else
  {
	  $self->{dimen} = new Math::Farnsworth::Dimension();
  }

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

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in addition" unless $one->{dimen}->compare($two); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new = new Math::Farnsworth::Value($one->{pari} + $tv, $one->{dimen});
  return $new;
}

sub subtract
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in addition" unless $one->{dimen}->compare($two); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} - $tv, $one->{dimen}); #if !$rev they are in order
  }
  else
  {
      $new = new Math::Farnsworth::Value($tv - $one->{pari}, $one->{dimen}); #if !$rev they are in order
  }
  return $new;
}

sub mult
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : {};
  
  my $nd = $one->{dimen}->merge($td); #merge the dimensions! don't cross the streams though

  #moving this down so that i don't do any math i don't have to
  my $new = new Math::Farnsworth::Value($one->{pari} * $tv, $nd);
  return $new;
}

sub div
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : {};
  
  $td = $one->{dimen}->invert($td); #NOTE: THIS DOES NOT ALTER $ONE AT ALL! this is just called that way for convienice

  my $nd = $one->{dimen}->merge($td); #merge the dimensions! don't cross the streams though

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} / $tv, $nd); #if !$rev they are in order
  }
  else
  {
      $new = new Math::Farnsworth::Value($tv / $one->{pari}, $nd); #if !$rev they are in order
  }

  return $new;

}
