package Math::Farnsworth::Value::Pari

use Math::Pari;
use Math::Farnsworth::Dimension;
use Date::Manip;
use List::MoreUtils 'each_array'; 
use Storable qw(dclone);

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

  $self->{array} = $value."" || "";
  
  return $self;
}


#######
#The rest of this code can be GREATLY cleaned up by assuming that $one is of type, Math::Farnsworth::Value::Pari, this means that i can slowly redo a lot of this code

sub getarray
{
	my $self = shift;
	return $self->{array};
}

sub add
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to addition" unless (!ref($two));

  #if we're not being added to a Math::Farnsworth::Value::Pari, the higher class object needs to handle it.
  confess "Scalar value given to addition to array" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->add($one, !$rev) unless ($two->isa(__PACKAGE__));
  if (!$two->ismediumtype("String"))
  {
    confess "Given non boolean to boolean operation";
  }

  #NOTE TO SELF this needs to be more helpful, i'll probably do this by creating an "error" class that'll be captured in ->evalbranch's recursion and use that to add information from the parse tree about WHERE the error occured
  die "Unable to process different units in addition\n" unless ($one->conforms($two)); 

  #moving this down so that i don't do any math i don't have to

  #ONLY THIS MODULE SHOULD EVER TOUCH ->{pari} ANYMORE! this might change into, NEVER
  my $order;
  $order = [@{$one->getarray()}, @{$two->getarray()}] unless $rev;
  $order = [@{$two->getarray()}, @{$one->getarray()}] if $rev;
  return new Math::Farnsworth::Value::Array($order); #concatenate the arrays
}

sub subtract
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to subtraction" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to subtraction to array" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->subtract($one, !$rev) unless ($two->isa(__PACKAGE__));

  die "Subtracting arrays? what did you think this would do, create a black hole?";
}

sub modulus
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to modulus" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to modulus to array" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->mod($one, !$rev) unless ($two->isa(__PACKAGE__));

  die "Modulusing arrays? what did you think this would do, create a black hole?";
}

sub mult
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to multiplication" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to multiplcation to array" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->mult($one, !$rev) unless ($two->isa(__PACKAGE__));

  die "Multiplying arrays? what did you think this would do, create a black hole?";
}

sub div
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to division" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Scalar value given to division to array" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->div($one, !$rev) unless ($two->isa(__PACKAGE__));

  die "Dividing arrays? what did you think this would do, create a black hole?";
}

sub bool
{
	my $self = shift;

	#seems good enough of an idea to me
	#i have a bug HERE
	#print "BOOLCONV\n";
	#print Dumper($self);
	#print "ENDBOOLCONV\n";
	return $self->getarray()?1:0;
}

sub pow
{
  my ($one, $two, $rev) = @_;

  confess "Non reference given to exponentiation" unless (!ref($two));

  #if there's a higher type, use it, subtraction otherwise doesn't make sense on arrays
  confess "Exponentiating arrays? what did you think this would do, create a black hole?" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->pow($one, !$rev) unless ($two->isa(__PACKAGE__));

  die "Exponentiating arrays? what did you think this would do, create a black hole?";
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
  confess "Scalar value given to division to array" if ($two->isa("Math::Farnsworth::Value::Pari"));
  return $two->compare($one, !$rev) unless ($two->isa(__PACKAGE__));

  my $rv = $rev ? -1 : 1;
  #check for $two being a simple value
  my $tv = $two->getarray();
  my $ov = $one->getarray();

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in compare\n" unless $one->conforms($two); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new = __compare($tv, $ov);
  
  return $new * $rv;
}

