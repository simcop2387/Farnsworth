#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
#use base 'Bot::BasicBot';
use POE qw(Component::IRC 
           Queue::Array 
           Component::IRC::Plugin::NickReclaim 
           Component::IRC::Plugin::CTCP
           Component::IRC::Plugin::Connector
           Component::IRC::Plugin::NickServID
		   Component::Client::HTTP);

use HTTP::Request;
use HTTP::Response;
use URI::Escape;
use Math::BigFloat;
use Encode;

#i should really move this to an external config
my $bots = {
        cubert => {
                poe => {
                        server => "irc.freenode.net",
#                       port => 6668,
                        nick => "cubert",
                        username => "cubert",
                        ircname => "Cubert Farnsworth",
#                       password => "cubert",
                        charset => "utf-8",
                        },
                url => "http://farnsworth:8081",
                channels => ["#yapb", "#buubot", "#perlcafe", "##turtles", "#stackvm"],
        },
	farnsworth => {
		poe => {
			server => "irc.freenode.net",
#			port => 6668,
			nick => "farnsworth",
			username => "farnsworth",
			ircname => "Hubert J. Farnsworth",
#			password => "farnsworth",
			charset => "utf-8",
			},
		url => "http://farnsworth:8080",
		channels => ["#yapb", "#buubot", "#perlcafe", "##turtles", "#stackvm", "#perl-cats"],
	},
	farnsworthriz => {
		poe => {
			server => "irc.rizon.net",
#			port => 6668,
			nick => "farnsworth",
			username => "farnsworth",
			ircname => "Hubert J. Farnsworth",
#			password => "farnsworth",
			charset => "utf-8",
			},
		url => "http://farnsworth:8080",
		channels => ["#dctv", "#dctp", "#uc-fansubs", "#yami", "#azfs", "#kienai"],
	},
};

my @ignore = qw(ChanServ GumbyBRAIN perlbot buubot frogbot NickServ *status);

my $http = POE::Component::Client::HTTP->spawn(
    Agent     => 'Farnsworth IRC 2000',
    Alias     => 'ua',
    From      => 'simcop2387@simcop2387.info',
);

POE::Session->create(
  package_states => 
    [
      main => [ qw(_start irc_001 irc_public irc_msg tock httpback lag_o_meter) ],
	],
    heap => { _config => $bots, bots => {}, http=>$http, httpqueue=>{}, reqcount=>0},);

POE::Kernel->run();

sub _start {
            my $heap = $_[HEAP];
			my $kernel = $_[KERNEL];
			my $config = $heap->{_config};

			for my $bot (keys %$config)
			{
				#create new IRC object from the config
				my $irc = POE::Component::IRC->spawn(%{$config->{$bot}{poe}});
				
				#fill out the heap
				$heap->{bots}{$irc}{id} = $bot;
				$heap->{bots}{$irc}{conf} = $config->{$bot};
				$heap->{bots}{$irc}{queue} = POE::Queue::Array->new();
				$heap->{bots}{$irc}{lastsend} = time();
				$heap->{bots}{$irc}{irc} = $irc;
				$heap->{bots}{$irc}{connector} = POE::Component::IRC::Plugin::Connector->new();

				$irc->plugin_add( 'Connector' => $heap->{bots}{$irc}{connector} );

				$irc->plugin_add( 'CTCP' => POE::Component::IRC::Plugin::CTCP->new(
	                version => "Language::Farnsworth SVN",
					userinfo => "See simcop2387 for more info", 
				));
				$irc->plugin_add( 'NickReclaim' => POE::Component::IRC::Plugin::NickReclaim->new( poll => 30 ) );
#need an external config for this to start again
#				$irc->plugin_add( 'NickServID', POE::Component::IRC::Plugin::NickServID->new(
#	                Password => $password,
#				)) if $password;

	            $irc->yield( register => 'all' );
				$irc->yield( connect => { } );
			}

            $kernel->delay_add(tock=>0.5); #tock sends out messages from the queues
            $kernel->delay( 'lag_o_meter' => 60 );
            return;
}

 sub lag_o_meter {
     my ($kernel,$heap) = @_[KERNEL,HEAP];
     
     print "--------\nTIME: ", time(), "\n";
     
     for (keys %{$heap->{bots}})
     {
     	print 'Bot: ', $heap->{bots}{$_}{id}, ' Lag: ', $heap->{bots}{$_}{connector}->lag() . "\n";
     }
  
     $kernel->delay( 'lag_o_meter' => 60 );
     return;
 }

sub irc_001 {
            my $sender = $_[SENDER];
			my $kernel = $_[KERNEL];
			my $heap = $_[HEAP];

            # Since this is an irc_* event, we can get the component's object by
            # accessing the heap of the sender. Then we register and connect to the
            # specified server.
            my $irc = $sender->get_heap();
			my @channels = @{$heap->{bots}{$irc}{conf}{channels}};

            print "Connected ", $heap->{bots}{$irc}{id}, " to ", $irc->server_name(), "\n";

            # we join our channels
            $irc->yield( join => $_ ) for (@channels);

            $irc->yield(nick => $heap->{bots}{$irc}{conf}{poe}{nick});
}

sub _ignore
{
  my $who = shift;
  return (grep {$who =~ /\Q$_/i} @ignore) ? 1 : 0
}

sub irc_public
{
  my ($kernel, $sender, $who, $where, $what, $heap) = @_[KERNEL, SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];
  my $irc = $sender->get_heap();
  my $myself = $heap->{bots}{$irc};
  my $mynick = $irc->nick_name;
 
  return if _ignore($nick);
  return if ($what =~ /^$mynick\+\+/);

  #+|- is because of shitty freenode shit
  if (my ($equation) = $what =~ /^(?:\+|\-)?$mynick[[:punct:]]\s*(.*)$/i)
  {
	#this needs to go to the new PoCo::Client::HTTP!
	makerequest($kernel, $heap, $myself, $equation, $nick, $channel, "pub");
  }
}

sub irc_msg
{
  my ($kernel, $sender, $who, $where, $what, $heap) = @_[KERNEL, SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];
  my $irc = $sender->get_heap();
  my $myself = $heap->{bots}{$irc};
  my $mynick = $irc->nick_name(); #whoami!

  return if _ignore($nick);
  return if ($what =~ /nknown command \[\] try 'Help'/);

  if (my $equation = $what)
  {
    #this needs the new PoCo::Client::HTTP!
	makerequest($kernel, $heap, $myself, $equation, $nick, $channel, "msg");
  }
}

sub tock
{
  my ($sender, $kernel, $heap) = @_[SENDER, KERNEL, HEAP];
  my @bots = keys %{$heap->{bots}};

  for my $bot (@bots)
  {
     my $myself = $heap->{bots}{$bot};
     my $np = $myself->{queue}->get_next_priority();

	 if ((defined($np)) && (time() - $myself->{lastsend} > 3))
	 {
	   my ($priority, $queue_id, $payload) = $myself->{queue}->dequeue_next();
	   print "TOCK: $priority, $queue_id\n";
	   $myself->{irc}->yield( privmsg => $payload->[0] => $payload->[1] );
	   $myself->{lastsend} = time();
     }
  }

  $kernel->delay_add(tock=>0.5);
}

sub makerequest
{
  my $kernel = shift;
  my $heap = shift; #get this from them!
  my $myself = shift;
  my $equation = shift;
  my $who = shift;
  my $where = shift;
  my $type = shift; #msg or pub

  my $reqid = $heap->{reqcount}++;
  my $url = $myself->{conf}{url};

  #set the escape for \cpn to be newline
  my $eq = $equation;
  $eq =~ s/(\cp|\\cp)n/\n/g;

  $eq = uri_escape($eq);

  my $realurl = "$url/$eq";
  my $req =  HTTP::Request->new(GET => $realurl); # a simple HTTP request

  $kernel->post(
    'ua', 'request',# http session alias & state
    'httpback', # my state to receive responses
    $req, # a simple HTTP request
    $reqid, # a tag to identify the request
  );  

  $heap->{httpqueue}{$reqid} = {who => $who, where => $where, type => $type, equation => $equation, myself => $myself, reqobj => $req, id => $reqid};
}

sub httpback
{
  my ($sender, $kernel, $heap) = @_[SENDER, KERNEL, HEAP];
  my ($request_packet, $response_packet) = @_[ARG0, ARG1];

  my $reqid = $request_packet->[1];
  my $response = $response_packet->[0];

  my $reqheap = $heap->{httpqueue}{$reqid};
  my $myself = $reqheap->{myself};

  my $outtext;

  if ($response->is_success)
  {
    my $q = $response->content();
	print Dumper($q, $response);
    $q = decode("UTF-8", $q);

    #these MAY dissappear!
    $q =~ s/\n/ /g; #filter a few annoying things
    $q =~ s/\s{2,}/ /g;
    $q =~ s/\s/ /g;

    _sanitize($q);

    if ((length $q > 300) && $reqheap->{type} ne "msg")
    {
      $q = "".(substr $q, 0, 300) . ".... tl;dr, use /msg";
      $q =~ s/\n//g; #tr probably faster, but who cares
    }

	$outtext = $q;
  }
  else
  {
    $outtext = "OH DEAR GOD NO! ".$response->status_line;
  }

  my @lines = messagebreak($outtext);

  if ($reqheap->{type} eq "msg")
  {
    my $pd = getpristart($myself->{queue}, $reqheap->{who});

    for my $p (0..$#lines)
    {
      print "LINE: $lines[$p]\n";
	
	  $myself->{queue}->enqueue($p+$pd, [$reqheap->{who}, $p == $#lines?"$lines[$p]":"$lines[$p] .."]);
	}
  }
  else
  {
    my $pd = getpristart($myself->{queue}, $reqheap->{where});

    for my $p (0..$#lines)
    {
      print "LINE: $lines[$p]\n";
	
	  $myself->{queue}->enqueue($p+$pd, [$reqheap->{where}, $reqheap->{who}.": $lines[$p]"]);
	}    
  }

  delete $heap->{httpqueue}{$reqid}; #clear out the old requests!
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

sub _sanitize
{
  $_[0]=~y/\000-\x1F//d;
  return $_[0];
}
