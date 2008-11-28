#!/usr/bin/perl

use Tk;
use strict;

{ local $/; $_ = <> }
print;
close STDOUT;

exit if /^undef/;

(my $mw = MainWindow->new)->title('Parse Tree');
my ($runx, $c) = (0, $mw->Canvas->pack(qw/-fill both -expand 1/));
show(eval($_), 40);
$c->Tk::bind('<3>' => \&exit);
MainLoop;

sub show    # (node, y)
  {
  my ($self, $y, @x) = @_;
  @x = map { show($_, $y+40) } @$self if ref $self;
  my $x = ($x[(@x-1)/2] + $x[@x/2])/2 || ($runx += 40);
	for(@x){ createLine $c $x, $y+8, $_, $y+40-8, -fill => 'red' }
  createText $c $x, $y, -text => ref $self || $self;
  $x
  }
