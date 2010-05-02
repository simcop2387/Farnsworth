#!/usr/bin/perl

use lib './lib';
use strict;
use warnings;

use Data::Dumper;

use Language::Farnsworth::Parser;

my $p = new Language::Farnsworth::Parser();

print Dumper($p->parse("2a**2"));
