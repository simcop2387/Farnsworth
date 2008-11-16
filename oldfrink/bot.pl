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
           port   => "6668",
           channels => ["#yapb", "#buubot", "#perl"],

           nick      => "frinkbot",
           alt_nicks => [map {"frinkbot".$_} 2..100],
           username  => "frinkbot",
           name      => "Mathbot",

           ignore_list => [qw(dipsy dadadodo laotse)],

           charset => "utf-8", # charset the bot assumes the channel is using

         );
         $bot->run();


sub said
{
 my $self = shift;
 my $args = shift;

print Dumper($args);

 if ($args->{address})
 {
   my $response = $self->submitform($args->{body}, $args->{address});
   my $simp = $self->simplify($response);
   return $simp;
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
#  my ($from, $to) = split(/->/, $eq, 2);
#  print "FRINK: $eq\n";

#  $from = uri_escape($from);
  $eq = uri_escape_utf8($eq);

  my $url="http://futureboy.homeip.net/fsp/frink.fsp?lookup=&toVal=&fromVal=$eq";

  print "URL: $url\n";

  my $ua = WWW::Mechanize->new(agent => "irc://irc.freenode.net/perl frinkbot madeby simcop2387");
  
  my $resp = $ua->get($url);

  if ($resp->is_success)
  {
    $ua->content() =~ /.*<a\s+name=["']?results["']?>(.*?)<\/a>.*/is; #parsing HTML with regex because WWW::Mech wouldn't DWIM
    my $linkresult = $1;
    $linkresult =~ s/\n/ /g; #filter a few annoying things
    $linkresult =~ s/<br>//gi; 
    $linkresult =~ s/\s{2,}/ /g;
    $linkresult = substr $linkresult, 0, length($linkresult)>100?100:length($linkresult) unless ($ad eq "msg");
    print "LINK: $1\n";
    return $linkresult;
  }
  else
  {
    return "OH DEAR GOD NO! ".$resp->status_line;
  }
}
