#!/usr/bin/perl -w

 use strict;
use warnings;
use Parse::RecDescent;
 use Data::Dumper;

 use vars qw(%VARIABLE);

 # Enable warnings within the Parse::RecDescent module.

 $::RD_ERRORS = 1; # Make sure the parser dies when it encounters an error
# $::RD_TRACE = 1; # Make sure the parser dies when it encounters an error
 $::RD_WARN   = 1; # Enable warnings. This will warn on unused rules &c.
 $::RD_HINT   = 1; # Give out hints to help fix problems.
 
 my $grammar = << 'HEREDOCS' ;

startrule: stmtlist /$/ { $item[1] }
	| <error: at $text>

stmtlist: stmt morestmt(s?) (';')(?) { bless [ $item[1], @{$item[2]} ], 'Stmt' }

morestmt: ';' stmt

stmt	: /while\b/ '(' lexpr ')' '{' stmtlist '}'
                         { bless [ @item[3,6] ], 'While' }
		| name '=' expr  { bless [ @item[1,3] ], 'Store' }
		| name '@' arrayexpr '$' '=' expr  { bless [ @item[1,3,6] ], 'ArrayStore' }
#		| name '{' argumentlist '}' ':=' '{' stmtlist '}' {bless [@item[1,3,7], 'FuncDef'}
		| expr

#i need to work this into expr!
lexpr	: expr '<' expr { bless [ @item[1,3] ], 'Lt' }
		| expr '>' expr { bless [ @item[1,3] ], 'Gt' }
		| expr '<=' expr { bless [ @item[1,3] ], 'Le' }
		| expr '<=>' expr { bless [ @item[1,3] ], 'Cmp' }
		| expr '>=' expr { bless [ @item[1,3] ], 'Ge' }
		| expr '==' expr { bless [ @item[1,3] ], 'Eq' }
		| expr '!=' expr { bless [ @item[1,3] ], 'Ne' }
		| expr '&&' expr { bless [ @item[1,3] ], 'And' }
		| expr '||' expr { bless [ @item[1,3] ], 'Or' }
		| expr '^^' expr { bless [ @item[1,3] ], 'Xor' }
		| '!' expr { bless [ @item[1,3] ], 'Not' }
		| expr { $item[1] } #this used to produce a != 0, but i've got that built in to my boolean stuff

expr	: term moreterm(s?)
					{
					my $v = $item[1];
					for(@{$item[2]}){ $v = bless [ $v, @$_ ], ref }
					$v;
					}

moreterm	: '+' term { bless [ $item[2] ], 'Add' }
			| '-' term { bless [ $item[2] ], 'Sub' }

term	: factor morefactor(s?)
					{
					my $v = $item[1];
					for(@{$item[2]}){ $v = bless [ $v, @$_ ], ref }
					$v;
					}

morefactor	: '*' factor { bless [ $item[2] ], 'Mul' }
			| '/' factor { bless [ $item[2] ], 'Div' }
			| '%' factor { bless [ $item[2] ], 'Mod' }
			| factor { bless [ $item[1], 'imp' ], 'Mul'}

factor : rawtoken moretokens(s?)
					{
					my $v = $item[1];
					for(@{$item[2]}){ $v = bless [ $v, @$_ ], ref }
					$v;
					}

moretokens : '**' rawtoken { bless [ $item[2] ], 'Pow' }
           | '^'  rawtoken { bless [ $item[2] ], 'Pow' }

rawtoken : number { bless [ $item[1] ], 'Num' }
		 | '(' expr ')' { bless [ $item[2] ], 'Paren' }
		 | '[' arrayexpr ']' { bless [ @{$item[2]} ], 'Array' }
		 | '#' /[^#]+/ '#' { bless [$item[2]], 'Date' }
         | '"' /(\\.|[^"\\])*/ '"' { bless [$item[2]], 'String' }
		 | name '@' arrayexpr '$' { bless [ $item[1], $item[3]], 'ArrayFetch' }
		 | name { bless [ $item[1] ], 'Fetch' }

arrayexpr : expr ',' arrayexpr { [$item[1], @{$item[3]}] }
          | expr { [$item[1]] }

number	: /\d+(?:\.\d*)?/
				| /\.\d+/

name	: /[a-z]\w*/i

HEREDOCS
;

my $parser = Parse::RecDescent->new($grammar);

print Dumper($parser->startrule('[1+1,[1+3]]'));
