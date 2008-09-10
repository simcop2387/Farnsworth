#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

   use Inline (
      Java => 'STUDY',
      STUDY => ['frink.parser.Frink'],
      CLASSPATH => './frink.jar',
   ) ;


my $frink = new frink::parser::Frink();
my $result = $frink->parseString("2+2");

print Dumper($result);
