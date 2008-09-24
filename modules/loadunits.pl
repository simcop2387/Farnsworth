#!/usr/bin/perl

open (my $fh, "<units.frns");

for (<$fh>)
{
	chomp;
	s|//.*$||;
	s|\s*$||;
	$scope->eval($_) if ($_ !~ /^\s*$/);
}

close ($fh);
