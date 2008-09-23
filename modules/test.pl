#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use Math::Farnsworth::Evaluate;

my $code = "1 == 2 ? 2 : 3";

my $scope = new Math::Farnsworth::Evaluate();

print "eval----\n";
my $return = $scope->eval($code);
print "tostring----\n";

print "$return\n";
