#!/usr/bin/perl

use lib '/home/ryan/farnsworth/lib';

use strict;
use warnings;
use Data::Dumper;
use URI::Escape;

use POE::Component::Server::HTTP;
use POE::Component::Server::TCP;
use HTTP::Status;
use POE;
use Encode;

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
  
  print $request->content();

  $response->add_content_utf8("COCKS");
  return RC_OK;
}

POE::Kernel->run();
