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

use Math::Farnsworth;

my $farnsworth = new Math::Farnsworth;
$farnsworth->runFile("startups/startup.frns");

my $aliases = POE::Component::Server::HTTP->new(
  Port => 8080,
  ContentHandler => {"/", \&runfarnsworth},
	Headers => { Server => "Farnsworth Server 1.2" },
  );

my $tcpserv = POE::Component::Server::TCP->new(
Port => 8081, 
ClientConnected =>
sub {
  print "HEARTBEAT\n";
  $_[HEAP]{client}->put("HEART");
},
ClientInput => sub {print "Dummy\n";}
);

sub runfarnsworth
{
  my ($request, $response) = @_;
  $response->code(RC_OK);
  my $string = "".(uri_unescape $request->uri);
  $string =~ s|^http://[^/]+/||;

  print "INPUT: $string\n\n\n\n";
  my $output;
  print "Running\n";
  eval 
	{
    my $out = ($farnsworth->runString($string));
    if (ref($out) eq "Math::Farnsworth::Value")
    {
      $output = $out->toperl($farnsworth->{eval}{units});
    }
    elsif (!defined($out))
    {
      $out = "Undefined || OK";
    }
    elsif (ref($out) eq "")
    {
      $output = $out;
    }
	};
  print "Done Running : $output\n";

  $output = $@ if $@;

  $response->content($output);
  return RC_OK;
}

POE::Kernel->run();
