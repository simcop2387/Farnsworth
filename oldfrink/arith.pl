#! /usr/bin/perl

# A simple arithmetic evaluation grammar using Parse::RecDescent.
#
# By Luc St-Louis, based on a presentation given by Benoit Beauséjour
# <bbeausej@pobox.com> to the Montreal Perl Mongers, on Thursday 1
# November 2001.
#
# Usage: echo 'x = 6; y = 7; print (x * y) % (y - 2)' | arith.pl

use strict;
use Parse::RecDescent;

$::RD_ERRORS = 1;
$::RD_WARN = 1;
$::RD_HINT = 1;
#$::RD_TRACE = 1;  # If defined, print parser trace.

my $vars = {};  # To hold our variables.

# --------------------------------------------------------------------
my $grammar = << 'EO_GRAMMAR';

startrule: COMMENT | CODE_LINE

COMMENT: /^\s*#/

CODE_LINE: INSTRUCTION(s /;/)

INSTRUCTION: ASSIGN_INST | PRINT_INST

ASSIGN_INST:
  VARIABLE ASSIGN_OP EXPR {
    $main::vars->{$item{VARIABLE}} = $item{EXPR};
  }

PRINT_INST:
  PRINT_OP EXPR {
    print $item{EXPR}, "\n";
  }

EXPR:
  TERM OP TERM {
    $return = eval "$item[1] $item[2] $item[3]";
  } |
  TERM {
    $return = $item[1];
  }

TERM:
  INTEGER {
    $return = $item[1];
  } |
  VARIABLE {
    $return = $main::vars->{$item{VARIABLE}},
  } |
  '(' EXPR ')' {
    $return = $item[2];
  }

OP: PLUS_OP | MINUS_OP | DIV_OP | TIMES_OP | MODULO_OP

INTEGER:    /[0-9]+/
VARIABLE:   /[a-z]\w*/i
ASSIGN_OP:  '='
PRINT_OP:   /print/i
PLUS_OP:    '+'
MINUS_OP:   '-'
DIV_OP:     '/'
TIMES_OP:   '*'
MODULO_OP:  '%'

EO_GRAMMAR

# --------------------------------------------------------------------
main();
sub main {
  my $parser = Parse::RecDescent->new($grammar);
  die "Error in grammar\n" unless $parser;
  while (<STDIN>) {
    $parser->startrule($_);
  }
}

