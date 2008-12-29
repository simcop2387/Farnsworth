package Math::Farnsworth::Value::Date

use Math::Pari;
use Math::Farnsworth::Dimension;

use DateTime;
use DateTime::Format::DateManip;
use Date::Manip;

use utf8;

our $VERSION = 0.6;

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
  my $outmagic = shift; #i'm still not sure on this one

  confess "Non string given as \$value to constructor" unless ref($value) eq "" && defined($value);

  my $self = {};

  bless $self, $class;

  $self->{outmagic} = $outmagic;
  $self->{valueinput} = $value;

  if (ref($value) ne "DateTime")
  {
	my $dm = ParseDate($value);
	my $dt = DateTime::Format::DateManip->parse_datetime($dm);

	$self->{date} = $dt;

	die "failed to parse date!" unless defined $dt;
  }
  else
  {
	$self->{date} = $value;
  }
 
  return $self;
}

sub getdate
{
	return $_[0]->{date};
}

#######
#The rest of this code can be GREATLY cleaned up by assuming that $one is of type, Math::Farnsworth::Value::Pari, this means that i can slowly redo a lot of this code

sub add
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to addition" unless (!ref($two));

  #if we're not being added to a Math::Farnsworth::Value::Pari, the higher class object needs to handle it.
  
  if ($two->isa("Math::Farnsworth::Value::Pari"))
  {
	  if ($two->conforms(TYPE_TIME))
	  {
		  return new Math::Farnsworth::Value::Date($one->clone()->add(seconds => $two->getpari()));
	  }
	  else
	  {
		  confess "Scalar value given to addition to string" if ($two->isa("Math::Farnsworth::Value::Pari"));
	  }
  }
  else
  {
	  return $two->add($one, !$rev) unless ($two->ismediumtype());
	  
	  if (!$two->ismediumtype("Date"))
	  {
	    confess "Given non date to date operation";
	  }

	  die "Adding dates does nothing useful.";
  }
}

sub subtract
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to subtraction" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  die "Scalar value given to subtraction to strings" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->subtract($one, !$rev) unless ($two->ismediumtype());
  if (!$two->ismediumtype("String"))
  {
    confess "Given non boolean to boolean operation";
  }

  die "Subtracting strings? what did you think this would do, create a black hole?";
}

sub modulus
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to modulus" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to modulus to string" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->mod($one, !$rev) unless ($two->ismediumtype());
  if (!$two->ismediumtype("String"))
  {
    confess "Given non string to string operation";
  }

  die "Modulusing strings? what did you think this would do, create a black hole?";
}

sub mult
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to multiplication" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to multiplcation to string" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->mult($one, !$rev) unless ($two->ismediumtype());
  if (!$two->ismediumtype("String"))
  {
    confess "Given non string to string operation";
  }

  die "Multiplying strings? what did you think this would do, create a black hole?";
}

sub div
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to division" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to division to string" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->div($one, !$rev) unless ($two->ismediumtype());
  if (!$two->ismediumtype("String"))
  {
    confess "Given non string to string operation";
  }

  die "Dividing string? what did you think this would do, create a black hole?";
}

sub bool
{
	my $self = shift;

	#seems good enough of an idea to me
	#i have a bug HERE
	#print "BOOLCONV\n";
	#print Dumper($self);
	#print "ENDBOOLCONV\n";
	return length($self->getstring())?1:0;
}

sub pow
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to exponentiation" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Exponentiating strings? what did you think this would do, create a black hole?" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->pow($one, !$rev) unless ($two->ismediumtype());
  if (!$two->ismediumtype("String"))
  {
    confess "Given non string to string operation";
  }


  die "Exponentiating strings? what did you think this would do, create a black hole?";
}

sub __compare
{
	my ($a1, $a2) = @_;
	my $same = 0;
	my $ea = each_array(@$a1, @$a2);
	
	while(my ($first, $second) = $ea->()) 
	{ 
		$same = $first > $second ? 1 : -1 and last if $first != $second 
	} # shortcircuits

	return $same;
}

sub compare
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to compare" unless (!ref($two));

  #if we're not being added to a Math::Farnsworth::Value::Pari, the higher class object needs to handle it.
  confess "Scalar value given to division to string" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->compare($one, !$rev) unless ($two->ismediumtype());

  my $rv = $rev ? -1 : 1;
  #check for $two being a simple value
  my $tv = $two->getstring();
  my $ov = $one->getstring();

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in compare\n" unless $one->conforms($two); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new = $tv cmp $ov;
  
  return $new * $rv;
}

