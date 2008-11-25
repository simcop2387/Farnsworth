package Math::Farnsworth::Value::Pari

use Math::Pari;
use Math::Farnsworth::Dimension;
use Date::Manip;
use List::Util qw(sum);
use Storable qw(dclone);

use utf8;

our $VERSION = 0.5;

use overload 
    '+' => \&add,
    '-' => \&subtract,
    '*' => \&mult,
    '/' => \&div,
	'%' => \&mod,
	'**' => \&pow,
	'<=>' => \&compare,
	'bool' => \&bool;

use base qw(Math::Farnsworth::Value);

#this is the REQUIRED fields for Math::Farnsworth::Value subclasses
#
#dimen => a Math::Farnsworth::Dimension object
#
#this is so i can make a -> conforms in Math::Farnsworth::Value, to replace the existing code, i'm also planning on adding some definitions such as, TYPE_PARI, TYPE_STRING, TYPE_LAMBDA, TYPE_DATE, etc. to make certain things easier

sub new
{
  my $class = shift;
  my $value = shift;
  my $dimen = shift; #should only really be used internally?
  my $outmagic = shift; #i'm still not sure on this one

  my $self = {};

  bless $self, $class;

  $self->{outmagic} = $outmagic;
  $self->{valueinput} = $value;

  if (ref($dimen) eq "Math::Farnsworth::Dimension")
  {
    $self->{dimen} = $dimen;
  }
  else
  {
	  $dimen = {} if !defined($dimen);
	  $self->{dimen} = new Math::Farnsworth::Dimension($dimen);
  }

  $value =~ s/(ee|E)/e/i; #fixes double ee's, i could probably eventually remove this, but it doesn't do any harm for now
  $self->{pari} = PARI $value;

  return $self;
}

#######
#The rest of this code can be GREATLY cleaned up by assuming that $one is of type, Math::Farnsworth::Value::Pari, this means that i can slowly redo a lot of this code

sub getpari
{
	my $self = shift;
	return $self->{pari};
}

sub getdimen
{
	my $self = shift;
	return $self->{dimen};
}

sub add
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to addition" unless (!ref($two));

  #if we're not being added to a Math::Farnsworth::Value::Pari, the higher class object needs to handle it.
  return $two->add($one, !$rev) unless ($two->isa(__PACKAGE__));

  #NOTE TO SELF this needs to be more helpful, i'll probably do this by creating an "error" class that'll be captured in ->evalbranch's recursion and use that to add information from the parse tree about WHERE the error occured
  die "Unable to process different units in addition\n" unless ($one->conforms($two)); 

  #moving this down so that i don't do any math i don't have to

  #ONLY THIS MODULE SHOULD EVER TOUCH ->{pari} ANYMORE! this might change into, NEVER
  return new Math::Farnsworth::Value::Pari($one->getpari() + $two->getpari(), $one->getdimen());
}

sub subtract
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to subtraction" unless (!ref($two));

  #if we're not being added to a Math::Farnsworth::Value::Pari, the higher class object needs to handle it.
  return $two->add($one, !$rev) unless ($two->isa(__PACKAGE__));

  #NOTE TO SELF this needs to be more helpful, i'll probably do this by creating an "error" class that'll be captured in ->evalbranch's recursion and use that to add information from the parse tree about WHERE the error occured
  die "Unable to process different units in subtraction\n" unless ($one->conforms($two)); 

  #moving this down so that i don't do any math i don't have to
  if (!$rev)
  {
	  return new Math::Farnsworth::Value($one->{pari} - $tv, $one->{dimen}); #if !$rev they are in order
  }
  else
  {
	  #i've never seen this happen, we'll see if it works
	  die "some mistake happened here in subtraction\n"; #to test later on
  }
}

sub mod
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in modulous\n" unless $one->{dimen}->compare($two->{dimen}); #always call this on one, since $two COULD be some other object 

  if ($one->{dimen}->compare({dimen => {string => 1}}) ||$one->{dimen}->compare({dimen => {array =>1}}) ||
	  $two->{dimen}->compare({dimen => {string => 1}}) ||$two->{dimen}->compare({dimen => {array =>1}}) ||
	  $two->{dimen}->compare({dimen => {bool => 1}})   ||$one->{dimen}->compare({dimen => {bool =>1}})  ||
	  $two->{dimen}->compare({dimen => {lambda => 1}})   ||$one->{dimen}->compare({dimen => {lambda =>1}})  ||
	  $two->{dimen}->compare({dimen => {date => 1}})   ||$one->{dimen}->compare({dimen => {date =>1}}))
  {
	  die "Can't divide arrays or strings or booleans or dates or lambdas, it doesn't make sense\n";
  }

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} % $tv, $one->{dimen}); #if !$rev they are in order
  }
  else
  {
      $new = new Math::Farnsworth::Value($tv % $one->{pari}, $one->{dimen}); #if !$rev they are in order
  }
  return $new;
}

sub mult
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : new Math::Farnsworth::Dimension();
  
  if ($one->{dimen}->compare({dimen => {string => 1}}) ||$one->{dimen}->compare({dimen => {array =>1}}) ||
	  $td->compare({dimen => {string => 1}}) ||$td->compare({dimen => {array =>1}}) ||
	  $td->compare({dimen => {bool => 1}})   ||$one->{dimen}->compare({dimen => {bool =>1}})  ||
	  $td->compare({dimen => {lambda => 1}})   ||$one->{dimen}->compare({dimen => {lambda =>1}})  ||
	  $td->compare({dimen => {date => 1}})   ||$one->{dimen}->compare({dimen => {date =>1}}))  {
	  die "Can't multiply arrays or strings, it doesn't make sense\n";
  }

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
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : new Math::Farnsworth::Dimension();

  if ($one->{dimen}->compare({dimen => {string => 1}}) ||$one->{dimen}->compare({dimen => {array =>1}}) ||
	  $td->compare({dimen => {string => 1}}) ||$td->compare({dimen => {array =>1}}) ||
	  $td->compare({dimen => {bool => 1}})   ||$one->{dimen}->compare({dimen => {bool =>1}})  ||
	  $td->compare({dimen => {lambda => 1}}) ||$one->{dimen}->compare({dimen => {lambda =>1}})  ||
	  $td->compare({dimen => {date => 1}})   ||$one->{dimen}->compare({dimen => {date =>1}})) 
  {
	  die "Can't divide arrays or strings, it doesn't make sense\n";
  }

  #these are a little screwy SO i'll probably comment them more later
  #probably after i find out that they're wrong
  my $qd = $rev ? $td : $one->{dimen};
  my $dd = $rev ? $one->{dimen}->invert() : (ref($td) eq "HASH" ? $td : $td->invert());

  my $nd;
  
  if (ref($qd) ne "HASH")
  {
	  $nd = $qd->merge($dd); #merge the dimensions! don't cross the streams though
  }
  else
  {
	  $nd = $dd->merge($qd); #merge them the other way, because $qd is a "HASH" and not an object
  }

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

sub bool
{
	my $self = shift;

	#seems good enough of an idea to me
	#i have a bug HERE
	#print "BOOLCONV\n";
	#print Dumper($self);
	#print "ENDBOOLCONV\n";
	return $self->{pari}?1:0;
}

sub pow
{
  my ($one, $two, $rev) = @_;

  if ($one->{dimen}->compare({dimen => {string => 1}}) ||$one->{dimen}->compare({dimen => {array =>1}}) ||
	  $two->{dimen}->compare({dimen => {string => 1}}) ||$two->{dimen}->compare({dimen => {array =>1}}) ||
	  $two->{dimen}->compare({dimen => {bool => 1}})   ||$one->{dimen}->compare({dimen => {bool =>1}})  ||
	  $two->{dimen}->compare({dimen => {lambda => 1}})   ||$one->{dimen}->compare({dimen => {lambda =>1}})  ||
	  $two->{dimen}->compare({dimen => {date => 1}})   ||$one->{dimen}->compare({dimen => {date =>1}})) 
  {
	  die "Can't exponentiate arrays or strings or dates or bools, it doesn't make sense\n";
  }

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : undef;

  if (defined($td) && !$td->compare({dimen=>{}}))
  {
	  die "A number with units as the exponent doesn't make sense";
  }

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} ** $tv, $one->{dimen}->mult($tv)); #if !$rev they are in order
  }
  else
  {
#	  print Dumper(\@_);
	  #print "POW: $tv :: $two :: $one\n";
      $new = new Math::Farnsworth::Value($tv ** $one->{pari}, $one->{dimen}->mult($tv)); #if !$rev they are in order
  }

  return $new;
}

sub compare
{
  my ($one, $two, $rev) = @_;

  my $rv = $rev ? -1 : 1;
  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in compare\n" unless $one->{dimen}->compare($two->{dimen}); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new;
  
  if ($one->{dimen}{dimen}{string})
  {
	  if ($one->{pari} eq $tv)
	  {
		  $new = 0;
	  }
	  elsif ($one->{pari} lt $tv)
	  {
		  $new = -1;
	  }
	  elsif ($one->{pari} gt $tv)
	  {
		$new = 1;
	  }
  }
  elsif ($one->{dimen}{dimen}{array})
  {
	  die "Comparing arrays has not been implemented\n";
  }
  elsif ($one->{dimen}{dimen}{lambdas})
  {
	  die "Comparing lambdas has not been implemented\n";
  }
  elsif ($one->{dimen}{dimen}{date})
  {
	  return Date_Cmp($one->{pari}, $two->{pari}); #does it for me!
  }
  else
  {
	  if ($one->{pari} == $tv)
	  {
		  $new = 0;
	  }
	  elsif ($one->{pari} < $tv)
	  {
		  $new = -1;
	  }
	  elsif ($one->{pari} > $tv)
	  {
		$new =1;
	  }
  }

  return $new;
}

