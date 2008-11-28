#!/usr/bin/perl

use Data::Dumper;
$Data::Dumper::Terse = 1;
use UP;
use strict;

my $s = join(' ', map { -T $_ ? `cat $_` : $_ } @ARGV) ||
	'qwe = 7*4+2/4; while(qwe > 0){print qwe; qwe = qwe - 1}';

print Dumper(UP->parse($s));
