#!/usr/bin/perl

use strict;
my %dict;

my $code = eval join '', <> or die "input failed $@";

$code->compute;

sub Add::compute { $_[0][0]->compute + $_[0][1]->compute }
sub Sub::compute { $_[0][0]->compute - $_[0][1]->compute }
sub Mul::compute { $_[0][0]->compute * $_[0][1]->compute }
sub Div::compute { $_[0][0]->compute / $_[0][1]->compute }
sub Mod::compute { $_[0][0]->compute % $_[0][1]->compute }
sub Lt::compute { $_[0][0]->compute < $_[0][1]->compute ? 1 : 0 }
sub Gt::compute { $_[0][0]->compute > $_[0][1]->compute ? 1 : 0 }
sub Le::compute { $_[0][0]->compute >= $_[0][1]->compute ? 1 : 0 }
sub Ge::compute { $_[0][0]->compute <= $_[0][1]->compute ? 1 : 0 }
sub Eq::compute { $_[0][0]->compute == $_[0][1]->compute ? 1 : 0 }
sub Ne::compute { $_[0][0]->compute != $_[0][1]->compute ? 1 : 0 }
sub Num::compute { $_[0][0] }
sub Store::compute { $dict{$_[0][0]} = $_[0][1]->compute }
sub Fetch::compute { $dict{$_[0][0]} }
sub Print::compute { print "output: ", $_[0][0]->compute, "\n" }
sub While::compute
	{
	my $v = 0;
	$v = $_[0][1]->compute while $_[0][0]->compute;
	$v
	}
sub Stmt::compute
	{
	my $v = 0;
	for(@{$_[0]}){ $v = $_->compute }
	$v
	}
sub For::compute
	{
	my $v = 0;
	$_[0][0]->compute;
	$_[0][2]->compute, $v = $_[0][3]->compute while $_[0][1]->compute;
	$v
	}
