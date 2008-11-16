#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

   use Inline (
      Java => 'STUDY',
      STUDY => ['frink.parser.Frink'],
      CLASSPATH => './tmp',
   ) ;


my $frink = new frink::parser::Frink();
my $result = $frink->parseString("2+2");

print Dumper($result);
