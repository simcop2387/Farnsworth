#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use Math::Farnsworth::Parser;
use Math::Farnsworth::Value;

my $parser = new Math::Farnsworth::Parser();

my $result = $parser->parse("quad[a,b,c]:=((-b + sqrt[b^2 +4 a c])/2a) b");

print Dumper($result);

my $val1 = Math::Farnsworth::Value->new(2**30, {meters=>1});

for (1..10)
{
	$val1 = $val1*2;
}

print $val1->toperl();
print Dumper($val1);
