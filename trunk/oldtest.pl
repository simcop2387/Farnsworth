#!/usr/bin/perl

use lib './lib';
use Language::Farnsworth::Parser::Extra; #provides a really nasty regex for lots of fun unicode symbols
my $uni = $Language::Farnsworth::Parser::Extra::regex; #get the really annoyingly named regex
my $identifier = qr/(?:\w|$uni)(?:[\w\d]|$uni)*/;

my $str = "foo bar";

if ($str =~ /\G($identifier)/cg)
{
  print "yes $1\n";
}

$str =~ /\G./cg;

if ($str =~ /\G($identifier)/cg)
{
  print "yes $1\n";
}
