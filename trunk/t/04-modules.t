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
	['module Test2 { defun test = {`x` eval[x]}; var z=42;}; 2', "2 ", "defining second module"],
	['F::Test2::test', '{`x` eval[ x ]; }', "getting the value of a function inside a module"],
	['Test2::test["1"]', '1 ', "Functions inside module calling global functions"],	
	['F::sin', '{`in isa 0 ` /* PERL CODE */}', "getting the value of a built in function"],
	['FUNCTION::cos', '{`in isa 0 ` /* PERL CODE */}', "getting the value of a built in function, long style"],
	['U::m', '1 m /* length */', "getting value of a unit"],
	['UNIT::m', '1 m /* length */', "getting value of a unit, long style"],
	['defun Test2::far={`x` x};', undef, "Unable to define a function inside a module from the outside"],
	['var Test2::boo=1;', undef, "Unable to define a variable inside a module from the outside"],
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
