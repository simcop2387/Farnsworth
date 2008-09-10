#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use strict;
use warnings;
use Data::Dumper;
use URI::Escape;
use URI::	_generic;

   use Inline (
      Java => 'STUDY',
      STUDY => ['frink.parser.Frink'],
      CLASSPATH => './frink.jar',
   ) ;

use POE::Component::Server::HTTP;
use HTTP::Status;

my $aliases = POE::Component::Server::HTTP->new(
  Port => 8080,
  ContentHandler => {"/", \&runfrink},
  Headers => { Server => "Frink Server 1.0" },
  );

my $frink = new frink::parser::Frink();

sub runfrink
{
  my ($request, $response) = @_;
  $response->code(RC_OK);
  my $string = "".(uri_unescape $request->uri);
  $string =~ s|^http://[^/]+/||;
  print "INPUT: $string\n\n\n\n";
  my $output;
  eval {$output = ($frink->parseString($string))};
  $response->content($output);
  return RC_OK;
}

chroot "/home/frink/frinkbot/chroot/";
chdir "/home/frink/frinkbot/chroot/";

POE::Kernel->run();
