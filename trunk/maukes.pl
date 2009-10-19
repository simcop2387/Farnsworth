#!/usr/bin/perl

use lib 'lib';

use Language::Farnsworth;

my $farnsworth = new Language::Farnsworth;
print "DONE STARTING UP!\n";


$farnsworth->runString("f_true = {`x`{`y`x}}; f_false = {`x`{`y`y}}; f_if = {`c`{`t`{`e`(c t e) []}}}; f_if f_false *{`` 2} *{`` 3}");
sleep(10);