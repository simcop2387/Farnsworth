#!/usr/bin/perl -w

 use strict;
 use Parse::RecDescent;
 use Data::Dumper;

 use vars qw(%VARIABLE);

 # Enable warnings within the Parse::RecDescent module.

 $::RD_ERRORS = 1; # Make sure the parser dies when it encounters an error
 $::RD_WARN   = 1; # Enable warnings. This will warn on unused rules &c.
 $::RD_HINT   = 1; # Give out hints to help fix problems.
 
 my $grammar = << 'HEREDOCS' ;

   # Terminals (macros that can't expand further)
   #

   OPL      : m([-+])         # Mathematical operators
   OPH		: m([*/%])        #higher precedence operators
   INTEGER  : /[-+]?\d+/      # Signed integers
   VARIABLE : /[a-z_][a-z0-9_]*/i # Variable

   token : VARIABLE {return $main::VARIABLE{$item{VARIABLE}}}
                    | INTEGER

   lowerorder  : <leftop: token /(\-|\+)/ token>
         		 { bless [@item], 'LOWORDER' }
			   | token

   expression : lowerorder

   print_instruction  : /print/i expression
                      { print $item{expression}."\n" }
   assign_instruction : VARIABLE "=" expression
                      { print Data::Dumper::Dumper(\%item); $main::VARIABLE{$item{VARIABLE}} = $item{expression} }

   instruction : print_instruction
               | assign_instruction

   startrule: instruction(s /;/)

HEREDOCS
;

 sub expression {
   print Dumper(\@_);
   shift;
   my ($lhs,$op,$rhs) = @_;
   #  $lhs = $VARIABLE{$lhs} if $lhs=~/[^-+0-9]/;
   #print "$lhs $op $rhs == " .(eval "$lhs $op $rhs")."\n";
   return eval "$lhs $op $rhs";
 }

 my $parser = Parse::RecDescent->new($grammar);


# print "a=2\n";             $parser->startrule("a=2");
# print "a=1+3\n";           $parser->startrule("a=1+3+4");
# print "print 5*7\n";       $parser->startrule("print 5*7");
# print "print 2/4\n";       $parser->startrule("print 2/4");
# print "print 2/4+3/2\n";   $parser->startrule("print 2/4+3/2");
 print "a=1-3+4\n";   $parser->startrule("a=1-3+4");
# print "print 2+2/4\n";     $parser->startrule("print 2+2/4");
# print "print 2+-2/4\n";    $parser->startrule("print 2+-2/4");
# print "a = 5 ; print a\n"; $parser->startrule("a = 5 ; print a");
