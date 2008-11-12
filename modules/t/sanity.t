#use Test::More tests => 23;
use Test::More qw(no_plan);

BEGIN { use_ok( 'Math::Farnsworth' ); use_ok('Math::Farnsworth::Value');}
require_ok( 'Math::Farnsworth' );
require_ok( 'Math::Farnsworth::Value' );

my $new = Math::Farnsworth->new(); #will attempt to load everything, doesn't die if it fails though, need a way to check that!.

my $expected = Math::Farnsworth::Value->new(4);
my $result = $new->runString("2+2");

is($expected, $result, "Simple addition");

$expected = $new->runString("sqrt[C[10]]");
