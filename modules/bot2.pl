#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
#use base 'Bot::BasicBot';
use POE qw(Component::IRC);
use WWW::Mechanize;
use URI::Escape;
use Math::BigFloat;
use Encode;

# with all known options
my $bot = POE::Component::IRC->spawn(

           server => "andromeda128",
           port   => "6668",
           nick      => "farnsworth",
           username  => "farnsworth",
           name      => "Hubert J. Farnsworth",

           charset => "utf-8", # charset the bot assumes the channel is using

         );

#channels => ["#yapb", "#buubot", "#perl", "#codeyard"],
#           alt_nicks => [map {"farnsworth".$_} 2..100],

POE::Session->create(
  package_states => 
    [
      main => [ qw(_start irc_001 irc_public irc_msg) ],
	],
    heap => { irc => $bot },);

POE::Kernel->run();

sub _start {
            my $heap = $_[HEAP];

            # retrieve our component's object from the heap where we stashed it
            my $irc = $heap->{irc};

            $irc->yield( register => 'all' );
            $irc->yield( connect => { } );
            return;
}

sub irc_001 {
            my $sender = $_[SENDER];

            # Since this is an irc_* event, we can get the component's object by
            # accessing the heap of the sender. Then we register and connect to the
            # specified server.
            my $irc = $sender->get_heap();

            print "Connected to ", $irc->server_name(), "\n";

            # we join our channels
            $irc->yield( join => $_ ) for (qw(\#yapb \#buubot \#perl \#codeyard));
            return;
}

sub irc_public
{
  my ($sender, $who, $where, $what, $heap) = @_[SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];

  if (my ($equation) = $what =~ /^farnsworth[[:punct:]]\s*(.*)$/i)
  {
    my $response = submitform($equation, "chan");	
	$heap->{irc}->yield( privmsg => $channel => "$nick: $response" );
  }
}

sub irc_msg
{
  my ($sender, $who, $where, $what, $heap) = @_[SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];

  if (my $equation = $what)
  {
    my $response = submitform($equation, "msg");	
	$heap->{irc}->yield( privmsg => $nick => "$response" );
  }
}

#sub help
#{
#  my $help = q{
#I know math-fu.  Have a look at  http://futureboy.homeip.net/frinkdocs/#HowFrinkIsDifferent to understand how to use me!
#If you have a question or function you would like preserved across crashes/restarts send a pm to simcop2387.};
#  $help =~ s/\n//g;
#  $help =~ s/\s{2,}/ /g;
#  
#  return $help;
#}

sub submitform
{
  my $eq = shift;
  my $ad = shift;

  #set the escape for \cpn to be newline
  $eq =~ s/(\cp|\\cp)n/\n/g;

  $eq = uri_escape_utf8($eq);

  my $url="http://localhost:8080/$eq";

  print "URL: $url\n";

  my $ua = WWW::Mechanize->new(agent => "irc://irc.freenode.net/perl frinkbot madeby simcop2387");
  
  my $resp = $ua->get($url);

  if ($resp->is_success)
  {
    my $q = $ua->content();
    $q = decode("UTF-8", $q);

    $q =~ s/\n/ /g; #filter a few annoying things
    $q =~ s/\s{2,}/ /g;

    if ((length $q > 320) && $ad ne "msg")
    {
      $q = "".(substr $q, 0, 320) . ".... tl;dr, use /msg";
    }

    return $q;
  }
  else
  {
    return "OH DEAR GOD NO! ".$resp->status_line;
  }
}
