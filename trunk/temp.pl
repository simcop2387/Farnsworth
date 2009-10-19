#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib './lib';

use Language::Farnsworth;
use Language::Farnsworth::Output;

my $scope = new Language::Farnsworth("FAKE.PM");

my $return = $scope->{eval}{parser}->parse('f{x = 30 isa foo} := 100x; 10 => {`foo isa x` 10}; [1,[2,2]]; a = [1,2,3,4,5,6,7,8,9,10,11]; if (10 < 12) {foobar => dunkers} else {x = f[10]; a@4$; a@10$ = 10 => {`x` 200 / x};}; "foobar\""; 10 m -> feet; volume :-> furlongs furlongs furlongs; ping =!= pong; ping := pong; pong ||| superpongs; #today#');
print Dumper($return);
print Language::Farnsworth::Output->deparsetree($return);
