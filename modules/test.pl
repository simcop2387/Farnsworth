#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use Math::Farnsworth;

my $scope = new Math::Farnsworth();

my $return = $scope->runString('10 m -> in');
print $return->toperl($scope->{units});
