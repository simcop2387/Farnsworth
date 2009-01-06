#!/usr/bin/perl

use strict;
my ($count, $var);
undef $/;
$_ = <>;

# store Tdddd load Tdddd

do
	{
	$count = 0;

	while( s/^
		\tstore\t(T\d{4})
		\s+load\t\1\s*\n
		//mx )
		{
		$var = $1;
		s/^$var\tdc\s*\n//m;
		$count++;
		}

	# store Tdddd load qwe add|mul Tdddd => add|mul qwe

	while( s/^
		\tstore\t(T\d{4})
		\s+load\t(\w+)
		\s+(add|mul)\t\1\s*\n
		/\t$3\t$2\n/mx )
		{
		$var = $1;
		s/^$var\tdc\s*\n//m;
		$count++;
		}

	# store Tdddd load qwe sub Tdddd => sub qwe chs

	while( s/^
		\tstore\t(T\d{4})
		\s+load\t(\w+)
		\s+sub\t\1\s*\n
		/\tsub\t$2\n\tchs\n/mx )
		{
		$var = $1;
		s/^$var\tdc\s*\n//m;
		$count++;
		}

	# redundant load

	while( s/^(
		\tstore\t(\w+)\n)
		\tload\t\2\n
		/$1/mx )
		{
		$count++;
		}

	# retarget jumps to other jumps

	while( /^
		(L\d{4}):\n
		(?:\#.*\n)*
		\s+(?:jump|jf)\s+(L\d{4})/mx )
		{
		my ($label, $target) = ($1, $2);
		s/^$label:\n//m;
		s/^\t(jump|jf)\t$label\n/\t$1\t$target\n/gm;
		$count++;
		}

	# duplicate jumps with comments in the middle

	while( s/^(
		\t(jump|jf)\t(L\d{4})\n
		(?:\#.*\n)*)
		\t\2\t\3\n
		/$1/mx )
		{
		$count++;
		}

	# multiple jumps with comments in the middle

	while( s/^(
		\tjump\tL\d{4}\n
		(?:\#.*\n)*)
		\tjump\t\w+\n
		/$1/mx )
		{
		$count++;
		}

	# jf next/jump target/next: => jt target

	while( s/^
		\tjf\t(L\d{4})\n
		\tjump\t(L\d{4})\n
		\1:\n
		/\tjt\t$2\n/mx )
		{
		$count++;
		}

	# pull Tdddd stores that are not used

	my @temps = /^(T\d{4})\tdc\n/gm;
	#print STDERR "temps: @temps\n";
	for my $tmp (@temps)
		{
		my @uses = /$tmp/mg;
		next if @uses > 2;
		s/^$tmp\tdc\n//m;
		s/^\tstore\t$tmp\n//m;
		$count++;
		}
	#print STDERR "$0 count $count\n" if $count;
	} while $count;

print;
