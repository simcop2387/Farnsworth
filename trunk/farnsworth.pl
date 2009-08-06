#!/usr/bin/perl

use lib 'lib';

use Math::Farnsworth;
use Math::Farnsworth::Error;

$Math::Farnsworth::Error::level = 2;

my $farnsworth = new Math::Farnsworth;
print STDERR "DONE STARTING UP!\n";

my $first = 1;
my $file = "";


while(<>)
{
  next if ($first && $_ =~ /#!/); #skip a shebang line!
  $file .= $_;
}




  my $out = $farnsworth->runString($file);
  my $output;

   if (ref($out) eq "Math::Farnsworth::Output")
    {
      $output = "".$out;
    }
    elsif (!defined($out))
    {
      $output = "Undefined || OK";
    }
    elsif (ref($out) eq "")
    {
      $output = $out;
    }
    else
    {
      $output = "BUG! +- ".ref($out)." -+ ".Dumper($out);
    }

print "$output\n";
