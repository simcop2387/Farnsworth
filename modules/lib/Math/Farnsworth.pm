#!/usr/bin/perl

package Math::Farnsworth;

our $VERSION = 0.5;

use strict;
use warnings;

use Math::Farnsworth::Evaluate;
use Math::Farnsworth::Value;
use Math::Farnsworth::Dimension;
use Math::Farnsworth::Units;
use Math::Farnsworth::FunctionDispatch;
use Math::Farnsworth::Variables;

use Carp qw(croak);

use Data::Dumper;

sub new
{
	shift; #get the class off

	my $self = {};
    my @modules = @_; #i get passed a list of modules to use for standard stuff;

	if (@modules < 1)
	{
		@modules = ("Units::Standard", "Functions::Standard", "Functions::StdMath", "Functions::GoogleTranslate"); #standard modules to include
	}

	print Dumper(\@modules);

	$self->{eval} = Math::Farnsworth::Evaluate->new();

	for (@modules)
	{
		eval 'use Math::Farnsworth::'.$_.'; Math::Farnsworth::'.$_.'::init($self->{eval});';
		print "-------FAILED? $_\n";
		print $@;
		print "\n";
	}

	bless $self;
	return $self;
}

sub runString
{
	my $self = shift;
	my @torun = @_; # we can run an array
	my @results;

	push @results, $self->{eval}->eval($_) for (@torun);

	return wantarray ? @results : $results[-1]; #return all of them in array context, only the last in scalar context
}

sub runFile
{
	my $self = shift;
	my $filename = shift;

	#my @results; #i should really probably only store them all IF they are needed

	open(my $fh, "<", $filename) or die "couldn't open: $!";
	my $lines;
	{local $/;
		$lines = <$fh>; #slurp the file! we need it!
	}
    close($fh);

	#as much as i would like this to work WITHOUT this i need to filter blank lines out
	$lines =~ s/\s*\n\s*\n\s*/\n/;
		
	return $self->{eval}->eval($lines);

#	while(<$fh>)
#	{
#		chomp;
		#s|//.*$||;
		#s|\s*$||;
#	}

#	close($fh);

		#return wantarray ? @results : $results[-1]; #return all of them in array context, only the last in scalar context
}

#this will wrap around a lot of the funky code for creating a nice looking output
sub prettyOut
{
}

1;
__END__

