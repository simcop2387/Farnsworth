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
	use_ok( 'Language::Farnsworth::Error' );
  }

require_ok( 'Language::Farnsworth' );
require_ok( 'Language::Farnsworth::Value' );
require_ok( 'Language::Farnsworth::Output' );
require_ok( 'Language::Farnsworth::Error' );

lives_ok {$Language::Farnsworth::Error::level = 2;} 'setting error level';

my $hubert;
lives_ok { $hubert = Language::Farnsworth->new();} 'Startup'; #will attempt to load everything, doesn't die if it fails though, need a way to check that!.

my @tests = 
(   
	['module Test { defun test = {`x` x+1}; var x=42;}; 1',        "1 ",             "defining a module lives"],
	['Test::x', "42 ", "accessing module variable"],
        ['Test::x = 2', "2 ", "assigning to module variable"],
	['Test::x', "2 ", "accessing module variable 2"],
	['Test::test[10]', "11 ", "calling module function"],
	['Test::x', "2 ", "accessing module variable 3, after module func"],
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
