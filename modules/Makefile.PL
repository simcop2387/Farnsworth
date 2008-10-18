#!env perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => "Math::Farnsworth",
   VERSION_FROM  => 'lib/Math/Farnsworth.pm',
   PREREQ_PM => {"Parse::Yapp" => 0},
);
