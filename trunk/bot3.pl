#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
#use base 'Bot::BasicBot';
use POE qw(Component::IRC 
           Queue::Array 
           Component::IRC::Plugin::NickReclaim 
           Component::IRC::Plugin::CTCP 
           Component::IRC::Plugin::NickServID);

use WWW::Mechanize;
use URI::Escape;
use Math::BigFloat;
use Encode;

#i should really move this to an external config
my $bots = {
	cubert => {
		poe => {
			server => "andromeda128",
			port => 6668,
			nick => "cubert",
			username => "cubert",
			ircname => "Cubert Farnsworth",
			password => "cubert",
			charset => "utf-8",
			},
		url => "http://127.0.0.1:8081/",
		channels => ["#yapb", "#buubot", "#perlcafe", "##turtles"],
	},
	farnsworth => {
		poe => {
			server => "andromeda128",
			port => 6668,
			nick => "farnsworth",
			username => "farnsworth",
			ircname => "Hubert J. Farnsworth",
			password => "farnsworth",
			charset => "utf-8",
			},
		url => "http://127.0.0.1:8080/",
		channels => ["#yapb", "#buubot", "#perlcafe", "##turtles"],
	},
	farnsworthriz => {
		poe => {
			server => "andromeda128",
			port => 6668,
			nick => "farnsworth",
			username => "farnsworth",
			ircname => "Hubert J. Farnsworth",
			password => "farnsworth",
			charset => "utf-8",
			},
		url => "http://127.0.0.1:8080/",
		channels => ["#yapb", "#buubot", "#perlcafe", "##turtles"],
	},
}

my @ignore = qw(ChanServ GumbyBRAIN perlbot buubot frogbot NickServ *status);

my $queue = POE::Queue::Array->new();

POE::Session->create(
  package_states => 
    [
      main => [ qw(_start irc_001 irc_public irc_msg tock) ],
	],
    heap => { _config => $bots, bots => {}, irc => $bot, queue => {}, lastsend=>time()},);

POE::Kernel->run();

sub _start {
            my $heap = $_[HEAP];
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
  my ($sender, $who, $where, $what, $heap) = @_[SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];
  my $irc = $sender->get_heap();
  my $myself = $heap->{bots}{$irc};
  my $mynick = $myself->{poe}{nick};
 
  return if _ignore($nick);
  return if ($what =~ /^$mynick\+\+/);

  #+|- is because of shitty freenode shit
  if (my ($equation) = $what =~ /^(?:\+|\-)?$mynick[[:punct:]]\s*(.*)$/i)
  {
	#this needs to go to the new PoCo::Client::HTTP!
  }
}

sub irc_msg
{
  my ($sender, $who, $where, $what, $heap) = @_[SENDER, ARG0 .. ARG2, HEAP];
  my $nick = ( split /!/, $who )[0];
  my $channel = $where->[0];
  my $irc = $sender->get_heap();
  my $myself = $heap->{bots}{$irc};
  my $mynick = $myself->{poe}{nick};

  return if _ignore($nick);
  return if ($what =~ /nknown command \[\] try 'Help'/);

  if (my $equation = $what)
  {
    #this needs the new PoCo::Client::HTTP!
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
