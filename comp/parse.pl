#!/usr/bin/perl

#$::RD_TRACE = 1;

use Parse::RecDescent;
use strict;

my $parse = new Parse::RecDescent <<'ENDGRAMMAR' or die "bad grammar";

goal: stmtlist /$/ { $item[1] }
		| <error: at $text>

stmtlist: stmt morestmt(s?) (';')(?) { bless [ $item[1], @{$item[2]} ], 'Stmt' }

morestmt: ';' stmt

stmt	: /while\b/ '(' lexpr ')' '{' stmtlist '}'
					{ bless [ @item[3,6] ], 'While' }
			| /print\b/ expr { bless [ $item[2] ], 'Print' }
			| name '=' expr { bless [ @item[1,3] ], 'Store' }
			| expr

lexpr	: expr '<' expr { bless [ @item[1,3] ], 'Lt' }
			| expr '>' expr { bless [ @item[1,3] ], 'Gt' }
			| expr '<=' expr { bless [ @item[1,3] ], 'Le' }
			| expr '>=' expr { bless [ @item[1,3] ], 'Ge' }
			| expr '==' expr { bless [ @item[1,3] ], 'Eq' }
			| expr '!=' expr { bless [ @item[1,3] ], 'Ne' }
			| expr { bless [ $item[1], bless [ 0 ], 'Num' ], 'Ne' }

expr	: term moreterm(s?)
					{
					my $v = $item[1];
					for(@{$item[2]}){ $v = bless [ $v, $_->[0] ], ref }
					$v;
					}

moreterm	: '+' term { bless [ $item[2] ], 'Add' }
					| '-' term { bless [ $item[2] ], 'Sub' }
					| '%' term { bless [ $item[2] ], 'Mod' }

term	: factor morefactor(s?)
					{
					my $v = $item[1];
					for(@{$item[2]}){ $v = bless [ $v, $_->[0] ], ref }
					$v;
					}

morefactor	: '*' factor { bless [ $item[2] ], 'Mul' }
						| '/' factor { bless [ $item[2] ], 'Div' }

factor	: number { bless [ $item[1] ], 'Num' }
				| '(' expr ')' { $item[2] }
				| name { bless [ $item[1] ], 'Fetch' }

number	: /\d+(?:\.\d*)?/
				| /\.\d+/

name	: /[a-z]\w*/i

ENDGRAMMAR

my $default = 'qwe=1;while(qwe<10){print qwe;qwe=qwe+2}';

my $in = join(' ', map { -T $_ ? `cat $_` : $_ } @ARGV) ||
	((-t) ? $default : <>);

use Data::Dumper;
$Data::Dumper::Terse = 1;
print Dumper($parse->goal($in));
