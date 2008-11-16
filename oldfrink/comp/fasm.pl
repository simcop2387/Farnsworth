#!/usr/bin/perl

use strict;
my ($pc, %op, %sym, @pass2, $op, $addr) = (0);
@op{`cat machine.d` =~ /^(\w+)/mg} = 0..99;

while(<>)
	{
	last if /^\s+end$/;
	$sym{$1} = exists $sym{$1} ? die("duplicate label: $1") : $pc if /^(\w+)/;
	$pc++, push @pass2, $1 if /^\w*\s+(\w+\s*\w*)$/;
	}
for(@pass2)
	{
	($op, $addr) = /^(\w+)\s*(\w*)$/;
	printf("%06d\n", $addr), next if $op eq 'dc';
	die "unknown op code: $op" unless exists $op{$op};
	die "undefined label: $addr" if $addr and not exists $sym{$addr};
	printf "%02d%04d\n", $op{$op}, $sym{$addr};
	}
