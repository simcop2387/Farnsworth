#!env perl

#testing again
#AGAIN
use strict;
use warnings;

use inc::Module::Install;

name "Math-Farnsworth";
all_from       'lib/Math/Farnsworth.pm';
version_from "lib/Math/Farnsworth.pm";
license 'artistic';
recommends 'REST::Google::Translate' => 0;
recommends 'Finance::Currency::Convert::XE' => 0;
#requires 'REST::Google::Translate' => 0;
#requires 'Finance::Currency::Convert::XE' => 0;

requires 'List::MoreUtils' => 0;
requires 'DateTimeX::Easy' => 0;
requires 'DateTime' => 0;
requires 'Math::Pari' => 0;

test_requires 'Test::More' => 0;
test_requires 'Test::Exception' => 0;

WriteAll;
