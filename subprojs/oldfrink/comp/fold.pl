#!/usr/bin/perl

use Data::Dumper;
$Data::Dumper::Terse = 1;
use strict;

my $code = eval join '', <> or die "input failed $@";

print Dumper($code->process);

sub UNIVERSAL::process
	{
	my $self = shift;
	bless [ map { ref $_ ? $_->process : $_ } @$self ], ref $self;
	}

sub Add::process
	{
	my $self = shift;
	return bless [ $self->[0][0] + $self->[1][0] ], 'Num'
		if ref $self->[0] eq 'Num' and ref $self->[1] eq 'Num';
	$self->UNIVERSAL::process
	}
