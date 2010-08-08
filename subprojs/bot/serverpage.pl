#!/usr/bin/perl

use lib '../../trunk/lib';

use strict;
use warnings;
use Data::Dumper;
use URI::Escape;
use CGI;

use POE::Component::Server::HTTP;
use POE::Component::Server::TCP;
use HTTP::Status;
use POE;
use Encode;

use Language::Farnsworth;
use Language::Farnsworth::Error;
use Language::Farnsworth::Units;

$Language::Farnsworth::Error::level = 3; #get all debugging

my $farnsworth = new Language::Farnsworth;
$farnsworth->runFile("startups/startup.frns");
$farnsworth->runFile("startups/combodefaults.frns");
$farnsworth->runFile("startups/datable.frns");
$farnsworth->runFile("startups/scales.frns");
print "DONE STARTING UP!\n";
$Language::Farnsworth::Units::lock = 1; #need better interface!

use utf8;

$|++;

my $aliases = POE::Component::Server::HTTP->new(
  Port => 8083,
  ContentHandler => {"/usereval", \&runfarnsworth},
	Headers => { Server => "Farnsworth Server 1.2" },
  );

sub runfarnsworth
{
  my ($request, $response) = @_;
  $response->code(RC_OK);

  my $string = "".($request->uri);
  $string =~ s|^http://[^/]+/usereval\?||;
  my $cgi = new CGI($string);  
  
  my $program = $request->content();
  
  my $output;
  print "Running\n";

  my $oa = $SIG{ALRM};
  my $oat = alarm(0);
  $SIG{ALRM} = sub {die "Timeout!"};
  alarm(25); #commented out for testing

  my $out = eval { my $ret=($farnsworth->runString($program)); $ret; };

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
  elsif (ref($out) eq "Language::Farnsworth::Error")
  {
    $output = "Error: ".($out->tostring()); 
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
	$output = "Got back Empty string for output, this is a bug\n";
  }
  print "Done Running : $output\n";

  $response->add_content_utf8("".$output);
  return RC_OK;
}

POE::Kernel->run();
