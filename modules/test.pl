#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use Math::Farnsworth::Evaluate;

my $code = "a = 42; a * a";

my $scope = new Math::Farnsworth::Evaluate();

#$scope->eval("a=42");
my $return = $scope->eval($code);

print $return->toperl()."\n";
