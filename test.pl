#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use frink;

my $parser = new frink();

my $result = $parser->parse("((-b + sqrt[b^2 +4 a c])/2a)");

print Dumper($result);

print $parser->YYNberr();
