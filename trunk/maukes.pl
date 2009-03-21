#!/usr/bin/perl

use lib 'lib';

use Math::Farnsworth;

my $farnsworth = new Math::Farnsworth;
print "DONE STARTING UP!\n";


$farnsworth->runString("f_true = {`x`{`y`x}}; f_false = {`x`{`y`y}}; f_if = {`c`{`t`{`e`(c t e) []}}}; f_if f_false *{`` 2} *{`` 3}");
$farnsworth->runString("f_succ = {`n`{`s`{`z`n s (s z)}}}; f_0 = {`s`{`z`z}}; f_1 = f_succ f_0; f_2 = f_succ f_1; f_is0 = {`n` n (f_true f_false) f_true}; f_is0 f_2");
