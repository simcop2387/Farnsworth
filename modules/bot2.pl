#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
#use base 'Bot::BasicBot';
use POE qw(Component::IRC Queue::Array);
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
           password  => "farnsworth",

           charset => "utf-8", # charset the bot assumes the channel is using

         );

my @ignore = qw(ChanServ GumbyBRAIN perlbot buubot frogbot NickServ *status);

#channels => ["#yapb", "#buubot", "#perl", "#codeyard"],
#           alt_nicks => [map {"farnsworth".$_} 2..100],

my $queue = POE::Queue::Array->new();

POE::Session->create(
  package_states => 
    [
      main => [ qw(_start irc_001 irc_public irc_msg tock) ],
	],
    heap => { irc => $bot, queue => $queue, lastsend=>time()},);

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
			my $kernel = $_[KERNEL];

            # Since this is an irc_* event, we can get the component's object by
            # accessing the heap of the sender. Then we register and connect to the
            # specified server.
            my $irc = $sender->get_heap();

            print "Connected to ", $irc->server_name(), "\n";

            # we join our channels
            $irc->yield( join => $_ ) for ("#yapb", "#buubot", "#perl", "#codeyard");
			$kernel->delay_add(tock=>0.5);
			return;
}

sub _ignore
{
  my $who = shift;
  return grep {lc($_) eq lc($who)} @ignore ? 1 : 0
}

sub irc_public
{
  my ($sender, $who, $where, $what, $heap) = @_[SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];

  return if _ignore($nick);

  if (my ($equation) = $what =~ /^farnsworth[[:punct:]]\s*(.*)$/i)
  {
    my $response = submitform($equation, "chan");	
	my @lines = messagebreak($response); #this should really never be needed, but is here so that its consistent
	
	my $pd = getpristart($heap->{queue}, $channel);

	for my $p (0..$#lines)
	{
		$heap->{queue}->enqueue($p+$pd, [$channel, "$nick: $lines[$p]"]);
	}
	#$heap->{irc}->yield( privmsg => $channel => "$nick: $response" );
  }
}

sub irc_msg
{
  my ($sender, $who, $where, $what, $heap) = @_[SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];

  print "PRIVMSG $nick: $what\n";

  return if _ignore($nick);
  return if ($what =~ /nknown command \[\] try 'Help'/);

  if (my $equation = $what)
  {
    my $response = submitform($equation, "msg");	
	my @lines = messagebreak($response);

    my $pd = getpristart($heap->{queue}, $nick);

	for my $p (0..$#lines)
	{
	    print "LINE: $lines[$p]\n";
		$heap->{queue}->enqueue($p+$pd, [$nick, $p == $#lines?"$lines[$p]":"$lines[$p] .."]);
	}
#	$heap->{irc}->yield( privmsg => $nick => "$response" );
  }
}

sub tock
{
  my ($sender, $kernel, $heap) = @_[SENDER, KERNEL, HEAP];

  my $np = $heap->{queue}->get_next_priority();
 
  if ((defined($np)) && (time() - $heap->{lastsend} > 3))
  {
	my ($priority, $queue_id, $payload) = $heap->{queue}->dequeue_next();
	print "TOCK: $priority, $queue_id\n";
	$heap->{irc}->yield( privmsg => $payload->[0] => $payload->[1] );
	$heap->{lastsend} = time();
  }

  $kernel->delay_add(tock=>0.5);
}

sub messagebreak
{
  use Text::Wrap;

  my ($message, $size) = @_;
                $size  = 320 unless $size;

  $Text::Wrap::columns = $size;

  my @pieces;

  if (length($message) > $size)
  { my $partial = "";
    my @lines = split(/\n/, $message);
    print "Message was too big, splitting\n";

    foreach my $line (@lines)
    {
      if (length($line) > $size)
      {
        #line too big, wrap her
        print "\tLine was too big wrapping\n";

        my @wrapped = split(/\n/, wrap("","",$line));
        push(@pieces, $partial) if (length($partial) > 0);
        $partial = pop(@wrapped);

        for my $wrap (@wrapped)
        {
          push(@pieces, $wrap);
        }
      }
      else
      {
        if (length($line) + length($partial) > $size)
        {
          push(@pieces, $partial);
          $partial = $line;
        }
        else
        {
          $partial = "$partial\n$line";
        }
      }
    }

    push(@pieces, $partial) if ($partial ne "")
  }
  else
  {
    push(@pieces, $message);
  }

  shift @pieces if ($pieces[0] =~ /^\s*$/);

  return (@pieces);
}

sub getpristart
{
   my $queue = shift;
   my $who = shift;

   my @items = $queue->peek_items(sub{ my $payload = shift; $payload->[0] eq $who});

   my $max = $items[0][0];
   shift @items;
   for my $item (@items) {if ($item->[0] > $max) {$max = $item->[0];}};

   $max ||= 0; #make sure its a numba!
   return $max+1; 
}

sub submitform
{
  my $eq = shift;
  my $ad = shift;

  #set the escape for \cpn to be newline
  $eq =~ s/(\cp|\\cp)n/\n/g;

  $eq = uri_escape($eq);

  my $url="http://localhost:8080/$eq";

  print "URL: $url\n";

  my $ua = WWW::Mechanize->new(agent => "irc://irc.freenode.net/perl frinkbot madeby simcop2387");
  
  my $resp = $ua->get($url);

  if ($resp->is_success)
  {
    my $q = $ua->content();
    $q = decode("UTF-8", $q);

    #these MAY dissappear!
    $q =~ s/\n/ /g; #filter a few annoying things
    $q =~ s/\s{2,}/ /g;

    if ((length $q > 300) && $ad ne "msg")
    {
      $q = "".(substr $q, 0, 300) . ".... tl;dr, use /msg";
    }

    return $q;
  }
  else
  {
    return "OH DEAR GOD NO! ".$resp->status_line;
  }
}
