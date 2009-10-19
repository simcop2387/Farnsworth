#!/usr/bin/perl

print "Loading units!\n";

open (my $fh, "<","units.frns");

print "Opened file!\n";

while(<$fh>)
{
	chomp;
	s|//.*$||;
	s|\s*$||;
	(print "$_\n"),$frink->eval($_) if ($_ !~ /^\s*$/);
}

close ($fh);

print "Done Loading!\n";
