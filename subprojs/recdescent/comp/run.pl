#!/usr/bin/perl -s

use integer;		# machine simulator
use strict;
my ($pc, $acc, $xr, $addr, @mem, $op, @inst) = (0, 0, 0);

@inst = map { eval "sub{$_}" or die $@ } `cat machine.d` =~ /^\w+\s+(.*)/mg;
@mem = (join '', <>) =~ /^(\d+)/mg;

open STDIN, '/dev/tty' or die "$! opening /dev/tty";

for(;; $acc = $acc < -999999 ? -999999 : $acc > 999999 ? 999999 : $acc)
	{
	$addr = abs($mem[$pc]) % 10000;
	&{$inst[$op = abs $mem[$pc++] / 10000] or die "invalid op code: $op"};
	}
