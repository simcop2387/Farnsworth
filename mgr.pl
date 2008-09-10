#!/usr/bin/perl

use strict;
use warnings;

use POE qw(Session Component::Client::TCP);

my $ses = POE::Session->create(
  inline_states =>
   { _start => \&start,
     alarm => \&alarm,
     gotbeat => \&gotbeat,
   },
);

sub start
{
  my ($heap, $kernel) = @_[HEAP, KERNEL];
  $heap->{beats} = 0;
  $heap->{nbeats} = 10;

  print "Start\n";
  $kernel->delay_add("alarm", 1);
}

sub alarm
{
  my ($heap, $kernel) = @_[HEAP, KERNEL];

  print "Checking Pulse: ".($heap->{beats}+10)." < ".$heap->{nbeats}."\n";

  if ($heap->{beats} + 10 < $heap->{nbeats})
  {
    print "It's dead jim\n";
#not responding need to restart
    $heap->{beats} = $heap->{nbeats} = 0; #reset the counters
    print "Finish him off first ".$heap->{pid}."\n";
    kill 9, $heap->{pid} if $heap->{pid};
    system(qw(pkill -9 java));
    sleep 5;

    print "Lets try to reimage him from the transporter!\n";
    $heap->{pid} = startserver();
  }

  getbeat(@_);

  $heap->{nbeats}++;
  
  $kernel->delay_add("alarm", 5);
}

sub startserver
{
  print "Reading pattern buffers\n";
  my $pid = fork();

  if ($pid == 0)
  {
    chdir "chroot";
    exec("../server.pl");
  }
  else
  {
    print "Found it in buffer $pid\n";
  }

  return $pid;
}

sub gotbeat
{
  my ($heap, $kernel) = @_[HEAP, KERNEL];

  print "Thump\n";

  $heap->{beats}++;
}

sub getbeat
{
  POE::Component::Client::TCP->new
  ( RemoteAddress => "localhost", RemotePort => "8081",
    ServerInput => 
    sub {
       my $kernel = $_[KERNEL]; 
       $kernel->post($ses, "gotbeat");
       $kernel->yield("shutdown");
    }
  );
}

$SIG{CHLD} = "IGNORE";

POE::Kernel->run();
