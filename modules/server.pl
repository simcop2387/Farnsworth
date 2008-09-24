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

use Math::Farnsworth::Evaluate;

my $frink = new Math::Farnsworth::Evaluate;

print "Loading units!\n";

open (my $fh, "<","units.frns");

print "Opened file!\n";

while(<$fh>)
{
	chomp;
	s|//.*$||;
	s|\s*$||;
	$frink->eval($_) if ($_ !~ /^\s*$/);
}

close ($fh);

print "Done Loading!\n";

my $aliases = POE::Component::Server::HTTP->new(
  Port => 8080,
  ContentHandler => {"/", \&runfrink},
  Headers => { Server => "Frink Server 1.0" },
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

#my $frink = new frink::parser::Frink();
#$frink->parseFilename("startup.frink");
#$frink->setRestrictiveSecurity(1); #true?

sub runfrink
{
  my ($request, $response) = @_;
  $response->code(RC_OK);
  my $string = "".(uri_unescape $request->uri);
  $string =~ s|^http://[^/]+/||;
#  $string =~ s/"/\\"/g;
#  $string = 'eval["'.$string.'"]';
  print "INPUT: $string\n\n\n\n";
  my $output;
  print "Running\n";
  eval {$output = ($frink->eval($string))->toperl($frink->{units});};
  print "Done Running : $output\n";

  $output = $@ if $@;

#  if (Inline::Java::caught("java.lang.Exception"))
#  {
#    $output = $@->getMessage();
#  }

  $response->content($output);
  return RC_OK;
}

POE::Kernel->run();
