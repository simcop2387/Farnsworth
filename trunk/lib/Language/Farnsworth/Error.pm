#!/usr/bin/perl

package Language::Farnsworth::Error;

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
    $eobj->{caller} = [caller()];
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
	print @messages,"\n" if $mlevel <= $level;
}

1;
__END__
=head1 NAME

Language::Farnsworth - A Turing Complete Language for Mathematics

=head1 SYNOPSIS

  use Language::Farnsworth::Error;
  
  error "Error message here";
  debug 1, "This only happens when the user isn't thinking properly";
  
  $Language::Farnsworth::Error::level = 3; # Change the level of debugging output for the current perl interpreter
  
=head1 DESCRIPTION

This is an internally used class for producing errors (Eventually it will be the standard way of producing errors in Language::Farnsworth plugins).
As I don't have a proper plugin system yet, nor all the features in here that i'd like i'm going to leave things like they are.

=head1 TODO

Add capturing information (maybe with a scope walker or something) to capture the current position in the farnsworth source.  This will also require support in the parser to annotate the source position and store the filename and things.

=head1 AUTHOR

Ryan Voots E<lt>simcop@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Ryan Voots

This library is free software; It is licensed exclusively under the Artistic License version 2.0 only.