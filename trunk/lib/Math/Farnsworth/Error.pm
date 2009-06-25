#!/usr/bin/perl

package Math::Farnsworth::Error;

use strict;
use warnings;

use Data::Dumper;
use Carp;

require Exporter;
our @ISA = qw(Exporter);

our @EXPORT = qw(error debug);

use overload '""' => \&tostring,
			 'eq' => \&eq;

our $level = 0; #debugging level, 0 means nothing, 1 means informative, 2 means all kinds of shit.

sub error
{
	my $err = shift;
	my $eobj = {};
    $eobj->{msg} = $err;
	bless $eobj;

	die $eobj;
}

sub tostring
{
	my $self = shift;
	return $self->{msg};
}

sub eq
{
	my ($one, $two, $rev) = @_;

	my $str = $one->tostring();
	return $str eq $two;
}

sub debug
{
	my ($mlevel, @messages) = @_;
	print @messages if $mlevel <= $level;
}

1
