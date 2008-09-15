#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use Math::Farnsworth::Parser;

my $parser = new Math::Farnsworth::Parser();

my $result = $parser->parse("((-b + sqrt[b^2 +4 a c])/2a) b");

print Dumper($result);

print $parser->YYNberr();
