#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use lib './lib';

use strict;
use warnings;
use Data::Dumper;
use URI::Escape;

use POE::Component::Server::HTTP;
use POE::Component::Server::TCP;
use HTTP::Status;
use POE;
use Encode;

use Language::Farnsworth;
use Language::Farnsworth::Error;
use Language::Farnsworth::Units;

use utf8;

$Language::Farnsworth::Error::level = 3; #get all debugging

my $farnsworth = new Language::Farnsworth;
$farnsworth->runFile("startups/startup.frns");
$farnsworth->runFile("startups/combodefaults.frns");
$farnsworth->runFile("startups/datable.frns");
$farnsworth->runFile("startups/scales.frns");
print "DONE STARTING UP!\n";
$Language::Farnsworth::Units::lock = 1; #need better interface!

my $aliases = POE::Component::Server::HTTP->new(
  Port => 8081,
  ContentHandler => {"/", \&runfarnsworth},
	Headers => { Server => "Farnsworth Server 1.2" },
  );

sub runfarnsworth
{
  my ($request, $response) = @_;
  $response->code(RC_OK);
  my $string = "".(uri_unescape $request->uri);
  $string =~ s|^http://[^/]+/||;
  $string = decode("UTF-8", $string);

  print "INPUT: $string\n\n\n\n";
  my $output;
  print "Running\n";

	  my $oa = $SIG{ALRM};
    my $oat = alarm(0);
    $SIG{ALRM} = sub {die "Timeout!"};
    alarm(180); #commented out for testing

  my $out = eval 
	{
		my $ret=($farnsworth->runString($string));
    $ret;
  };

    alarm(0);
    $SIG{ALRM} = $oa;
    alarm($oat);

	if ($@)
    {
	  	$output = $@;
    }
    elsif (ref($out) eq "Language::Farnsworth::Output")
    {
      $output = "".$out;
    }
    elsif (!defined($out))
    {
      $output = "Undefined || OK";
    }
    elsif (ref($out) eq "")
    {
      $output = $out;
    }
    else
    {
      $output = "BUG! +- ".ref($out)." -+ ".Dumper($out);
    }

	if (!defined($output) || $output eq "")
	{
		$output = "Got back Empty string for outpt, this is a bug\n";
	}
  print "Done Running : $output\n";

  $response->add_content_utf8(" ".$output);
  return RC_OK;
}

POE::Kernel->run();
