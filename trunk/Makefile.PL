#!env perl

use strict;
use warnings;

use inc::Module::Install;

name "Math-Farnsworth";
all_from       'lib/Math/Farnsworth.pm';
version_from "lib/Math/Farnsworth.pm";
license 'perl';
recommends 'REST::Google::Translate' => '0.50';

requires 'List::MoreUtils' => 0;
requires 'Date::Manip' => 0;
requires 'Math::Pari' => 0;

test_requires 'Test::More' => 0;
test_requires 'Test::Exception' => 0;

no_index directory => 'startups'; #directory for the IRC bot i run for development and testing

WriteAll;
