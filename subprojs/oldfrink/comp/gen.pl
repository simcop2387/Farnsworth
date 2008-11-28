#!/usr/bin/perl

use strict;
my (%syms, %nums, $nexttmp, $nextlabel);
my $code = eval join '', <> or die "input failed $@";

$code->compute;
print "\thalt\n";
print map "$_\tdc\n", sort keys %syms;
print map "_$_\tdc\t$_\n", sort {$a <=> $b} keys %nums;
print map { sprintf "T%04d\tdc\n", $_ } 1..$nexttmp;
print "\tend\n";

sub newtmp { sprintf "T%04d", ++$nexttmp }
sub newlabel { sprintf "L%04d", ++$nextlabel }

sub binop
	{
	my ($op, $thing) = @_;
	my ($left, $right, $tmp) =
		($thing->[0]->compute, $thing->[1]->compute, &newtmp);
	print "\tload\t$left\n\t$op\t$right\n\tstore\t$tmp\n";
	$tmp;
	}

sub Add::compute { binop 'add', @_ }
sub Sub::compute { binop 'sub', @_ }
sub Mul::compute { binop 'mul', @_ }
sub Div::compute { binop 'div', @_ }
sub Mod::compute { binop 'mod', @_ }
sub Lt::compute { binop 'lt', @_ }
sub Gt::compute { binop 'gt', @_ }
sub Ge::compute { binop 'ge', @_ }
sub Le::compute { binop 'le', @_ }
sub Eq::compute { binop 'eq', @_ }
sub Ne::compute { binop 'ne', @_ }
sub Num::compute
	{
	my $n = $_[0][0];
	$nums{$n}++;
	"_$n";
	}
sub Fetch::compute { $_[0][0] }
sub Store::compute
	{
	my $self = shift;
	my ($left, $right) = ($self->[0], $self->[1]->compute);
	$syms{$left}++;
	print "\tload\t$right\n\tstore\t$left\n";
	$left;
	}
sub Print::compute
	{
	my $v = $_[0][0]->compute;
	print "\tload\t$v\n\toutput\n";
	$v
	}
sub Stmt::compute
	{
	my $v = 0;
	for(@{$_[0]}){ $v = $_->compute }
	$v
	}
sub While::compute
	{
	my ($top, $bottom) = (&newlabel, &newlabel);
	print "$top:\n";
	my $v = $_[0][0]->compute;
	print "\tload\t$v\n\tjf\t$bottom\n";
	$_[0][1]->compute;
	print "\tjump\t$top\n$bottom:\n";
	}
sub For::compute
	{
	my ($top, $bottom) = (&newlabel, &newlabel);
	$_[0][0]->compute;
	print "\tjump\t$bottom\n$top:\n";
	$_[0][3]->compute;
	$_[0][2]->compute;
	print "$bottom:\n";
	my $v = $_[0][1]->compute;
	print "\tload\t$v\n\tjt\t$top\n";
	}
