#use Test::More tests => 23;
  
  BEGIN 
  {
 	  eval "use Test::Exception";

    if ($@)
    {
		  eval 'use Test::More; plan skip_all => "Test::Exception needed"' if $@
    }
    else
    {
	    eval 'use Test::More; plan no_plan';
    }

	  use_ok( 'Language::Farnsworth' ); use_ok('Language::Farnsworth::Value'); use_ok('Language::Farnsworth::Output');
  }

require_ok( 'Language::Farnsworth' );
require_ok( 'Language::Farnsworth::Value' );
require_ok( 'Language::Farnsworth::Output' );

my $hubert;
lives_ok { $hubert = Language::Farnsworth->new();} 'Startup'; #will attempt to load everything, doesn't die if it fails though, need a way to check that!.

my @tests = 
(   
	["var a=[1,2,3];",        "[1  , 2  , 3 ]",             "array creation for subsequent tests"],
	["push[a,4];",            "[1  , 2  , 3  , 4 ]",        "push[array, single]"],
	["push[a,1,2,3];",        "[1  , 2  , 3  , 4  , 1  , 2  , 3 ]",        "push[array, multiple]"],
	["push[a,[3.14, 4.5]];",  "[1  , 2  , 3  , 4  , 1  , 2  , 3  , [3.14  , 4.5 ]]",        "push[array, [multiple in array]]"],
        ["pop[a]",                "[3.14  , 4.5 ]",  "pop[] pull off last push"],
        ["shift[a]",              "1 ",  "shift[] off first element"],
	["unshift[a,1]",          "[1  , 2  , 3  , 4  , 1  , 2  , 3 ]", "unshift[] back onto array"],
#	["sort[{`a,b` a <=> b}, 2,1,4,3]", "[1  , 2  , 3  , 4 ]", "sort[] list"],
	["sort[{`a,b` a <=> b}, a]", "[1  , 1  , 2  , 2  , 3  , 3  , 4 ]", "sort[] array"],
	["length[a]", "7 ", "length[] array"],
	['length["Hello World"]', "11 ", "length[] string"],
	['ord["a"]', "97 ", "ord[] ascii"],
#	['ord["# "]', "97 ", "ord[] unicode"], #can't type from here
#	['chr[97]', '"a"' 

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
		dies_ok {$hubert->runString($farn);} $name;
	}
}
