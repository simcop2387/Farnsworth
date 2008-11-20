#use Test::More tests => 23;
use Test::More;
  
  BEGIN 
  {
	  eval "use Test::Exception";
      plan skip_all => "Test::Exception needed" if $@;

	  plan no_plan;
	  use_ok( 'Math::Farnsworth' ); use_ok('Math::Farnsworth::Value'); use_ok('Math::Farnsworth::Output');
  }

require_ok( 'Math::Farnsworth' );
require_ok( 'Math::Farnsworth::Value' );
require_ok( 'Math::Farnsworth::Output' );

my $hubert;
lives_ok { $hubert = Math::Farnsworth->new();} 'Startup'; #will attempt to load everything, doesn't die if it fails though, need a way to check that!.

my @tests = 
(   ["4 + 4",  "8 ",             "addition"],
	["4 4",    "16 ",            "implicit multiplcation"],
	["4 * 4",  "16 ",            "multiplication"],
	["4 per 4", "1 ",            "division, per"],
	["4 / 4",  "1 ",             "division"],
	["4 - 4",  "0 ",             "subtraction"],
	["4 - 4.", "(0.e-114) ",     "subtraction, floating"],
	["4 s",    "4 s /* time */", "units, time"],
	["4/0",    undef,            "division by zero"], #undef signals it should die
	["3 + 3 s", undef,           "inconsistent units"], #undef signals it should die
	["2 ** (2 s)", undef,        "units in power"], #undef signals it should die
	["2**2",    "4 ",            "exponents"], #undef signals it should die
#	["4s ** 2",  "4 s^2 ",      "operator precedence"], #operator precedence when having no space doesn't work right! bug in parser
	["log[10 m]", undef,         "log of units"],
	["log[10]",  "1.0 ",         "log"], 
	["sin[0 radians]",  "(0.e-115) ",         "sin"], 
	["sin[45 degrees]^2",  "0.5 ",         "sin squared"], 
);


for my $test (@tests)
{
	my $farn = $test->[0];
	my $expected = $test->[1];
	my $name = $test->[2];

	if (defined($expected))
	{
		lives_and {is $hubert->runString($farn), $expected, $name} $name." lives";
	}
	else
	{
		dies_ok {$hubert->runString($farn);} 'divide by zero';
	}
}
