#!/usr/bin/perl

package FrinkBot;

use strict;
use warnings;
use Data::Dumper;
use base 'Bot::BasicBot';
use WWW::Mechanize;
use URI::Escape;
use Math::BigFloat;

         # with all known options
         my $bot = FrinkBot->new(

           server => "andromeda128",
           port   => "6669",
           channels => ["#yapb", "#buubot", "#codeyard"],

           nick      => "frinkbot",
           alt_nicks => [map {"frinkbot".$_} 2..100],
           username  => "frinkbot",
           name      => "Mathbot",

           ignore_list => [qw(dipsy dadadodo laotse)],

           charset => "utf-8", # charset the bot assumes the channel is using

         );
         $bot->run();

sub help
{
  my $help = q{
I know math-fu.  Have a look at  http://futureboy.homeip.net/frinkdocs/#HowFrinkIsDifferent to understand how to use me!
If you have a question or function you would like preserved across crashes/restarts send a pm to simcop2387.};
  $help =~ s/\n//g;
  $help =~ s/\s{2,}/ /g;
  
  return $help;
}


sub said
{
 my $self = shift;
 my $args = shift;

print Dumper($args);

 if ($args->{address}) 
 {
   if ($args->{body} !~ /(read|lines|staticjava|newjava|calljava)/i)
   {
     my $response = $self->submitform($args->{body}, $args->{address});
     return $response;
   }
   else
   {
     return "The function you are attempting to use is restricted"
   }
 }

 return undef;
}

sub simplify
{
  my $self = shift;
  my $in = shift;

  $in =~ m|([\d.-]+/[\d.]+)|;
  my $num = $1;


  if (defined $num)
  {
    print "NUM: $num\n";
    my ($q, $d) = split "/", $num;

    print "QD: $q :: $d\n";
    my $out = $q/$d;

    $in =~ s/$num/$out/;

  }
  return $in
  
}

sub submitform
{
  my $self = shift;
  my $eq = shift;
  my $ad = shift;

  #set the escape for \cpn to be newline
  $eq =~ s/(\cp|\\cp)n/\n/g;

  $eq = uri_escape_utf8($eq);

  my $url="http://localhost:8084/$eq";

  print "URL: $url\n";

  my $ua = WWW::Mechanize->new(agent => "irc://irc.freenode.net/perl frinkbot madeby simcop2387");
  
  my $resp = $ua->get($url);

  if ($resp->is_success)
  {
    my $q = $ua->content();

    $q =~ s/\n/ /g; #filter a few annoying things
    $q =~ s/\s{2,}/ /g;

    if ((length $q > 220) && $ad ne "msg")
    {
      $q = "SHORTENED [SEEALL USING /MSG]: ".(substr $q, 0, 220);
    }

    return $q;
  }
  else
  {
    return "OH DEAR GOD NO! ".$resp->status_line;
  }
}
