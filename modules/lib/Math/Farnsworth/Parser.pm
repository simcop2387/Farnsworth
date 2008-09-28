####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Math::Farnsworth::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 15 "Farnsworth.yp"

use Data::Dumper; #boobs
use Text::Balanced qw(extract_delimited);
my $s;		# warning - not re-entrant
my $fullstring;
my $charcount;


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			"-" => 1,
			'NAME' => 8,
			"var" => 10,
			'DATE' => 2,
			"{" => 12,
			"while" => 13,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 14,
			'while' => 16,
			'stma' => 9,
			'expr' => 5,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 17,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 2
		DEFAULT => -57
	},
	{#State 3
		DEFAULT => -59
	},
	{#State 4
		DEFAULT => -58
	},
	{#State 5
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			":->" => 30,
			"!=" => 31,
			"|||" => 32,
			"?" => 33,
			"/" => 35,
			"->" => 34,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -4
	},
	{#State 6
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'array' => 39,
			'expr' => 40,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 7
		DEFAULT => -23
	},
	{#State 8
		ACTIONS => {
			"[" => 41,
			"::-" => 45,
			"|" => 47,
			":=" => 42,
			"=!=" => 44,
			"{" => 43,
			"=" => 46,
			":-" => 48
		},
		DEFAULT => -24
	},
	{#State 9
		ACTIONS => {
			'' => 49
		}
	},
	{#State 10
		ACTIONS => {
			'NAME' => 51
		},
		GOTOS => {
			'assignexpr' => 50
		}
	},
	{#State 11
		ACTIONS => {
			"(" => 15,
			'NUMBER' => 7,
			'NAME' => 52
		},
		DEFAULT => -30,
		GOTOS => {
			'exprval' => 53
		}
	},
	{#State 12
		ACTIONS => {
			"|" => 54
		}
	},
	{#State 13
		ACTIONS => {
			"(" => 55
		}
	},
	{#State 14
		ACTIONS => {
			";" => 56
		},
		DEFAULT => -2
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 57,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 16
		DEFAULT => -11
	},
	{#State 17
		ACTIONS => {
			"**" => 21,
			"^" => 26
		},
		DEFAULT => -31
	},
	{#State 18
		ACTIONS => {
			"[" => 41,
			"::-" => 45,
			"|" => 47,
			"{" => 43,
			"=" => 46,
			":-" => 48
		},
		DEFAULT => -24
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 58,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 59,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 21
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 60,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 61,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 62,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 63,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 64,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 65,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 66,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 67,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 68,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 69,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 70,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 32
		ACTIONS => {
			'NAME' => 71
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 72,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 73,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 74,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 75,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 77,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 39
		ACTIONS => {
			"]" => 78
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"," => 79,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"/" => 35,
			"->" => 34,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -14
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 11,
			'argarray' => 81,
			'assignexpr' => 3
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 82,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 43
		ACTIONS => {
			'NAME' => 84
		},
		GOTOS => {
			'arglist' => 85,
			'argelement' => 83
		}
	},
	{#State 44
		ACTIONS => {
			'NAME' => 86
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 87,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 46
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 88,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'array' => 89,
			'expr' => 40,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 90,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 49
		DEFAULT => 0
	},
	{#State 50
		DEFAULT => -6
	},
	{#State 51
		ACTIONS => {
			"=" => 46
		},
		DEFAULT => -5
	},
	{#State 52
		ACTIONS => {
			"[" => 41,
			"|" => 91
		},
		DEFAULT => -24
	},
	{#State 53
		ACTIONS => {
			"(" => 15,
			'NUMBER' => 7,
			'NAME' => 52
		},
		DEFAULT => -28,
		GOTOS => {
			'exprval' => 53
		}
	},
	{#State 54
		ACTIONS => {
			'NAME' => 84
		},
		GOTOS => {
			'arglist' => 92,
			'argelement' => 83
		}
	},
	{#State 55
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 93,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 56
		ACTIONS => {
			"-" => 1,
			'NAME' => 8,
			"var" => 10,
			'DATE' => 2,
			"{" => 12,
			"while" => 13,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 14,
			'while' => 16,
			'stma' => 94,
			'expr' => 5,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 57
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			")" => 95,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		}
	},
	{#State 58
		ACTIONS => {
			"**" => 21,
			"%" => 23,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"/" => 35
		},
		DEFAULT => -34
	},
	{#State 59
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -42
	},
	{#State 60
		DEFAULT => -40
	},
	{#State 61
		ACTIONS => {
			"**" => 21,
			"%" => 23,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"/" => 35
		},
		DEFAULT => -33
	},
	{#State 62
		ACTIONS => {
			"**" => 21,
			"^" => 26
		},
		DEFAULT => -38
	},
	{#State 63
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -46
	},
	{#State 64
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -45
	},
	{#State 65
		DEFAULT => -39
	},
	{#State 66
		ACTIONS => {
			"**" => 21,
			"^" => 26
		},
		DEFAULT => -32
	},
	{#State 67
		ACTIONS => {
			"**" => 21,
			"^" => 26
		},
		DEFAULT => -35
	},
	{#State 68
		ACTIONS => {
			"**" => 21,
			"%" => 23,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"/" => 35
		},
		DEFAULT => -37
	},
	{#State 69
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -8
	},
	{#State 70
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -48
	},
	{#State 71
		DEFAULT => -10
	},
	{#State 72
		ACTIONS => {
			":" => 96,
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		}
	},
	{#State 73
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -56
	},
	{#State 74
		ACTIONS => {
			"**" => 21,
			"^" => 26
		},
		DEFAULT => -36
	},
	{#State 75
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -47
	},
	{#State 76
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -44
	},
	{#State 77
		ACTIONS => {
			"-" => 19,
			"<" => undef,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => undef,
			">=" => undef,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => undef,
			"/" => 35,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -43
	},
	{#State 78
		DEFAULT => -53
	},
	{#State 79
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'array' => 97,
			'expr' => 40,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 80
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"," => 98,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"/" => 35,
			"->" => 34,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -16
	},
	{#State 81
		ACTIONS => {
			"]" => 99
		}
	},
	{#State 82
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -7
	},
	{#State 83
		ACTIONS => {
			"," => 100
		},
		DEFAULT => -22
	},
	{#State 84
		ACTIONS => {
			"isa" => 102,
			"=" => 101
		},
		DEFAULT => -20
	},
	{#State 85
		ACTIONS => {
			"}" => 103
		}
	},
	{#State 86
		DEFAULT => -9
	},
	{#State 87
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -49
	},
	{#State 88
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -29
	},
	{#State 89
		ACTIONS => {
			"|" => 104
		}
	},
	{#State 90
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -50
	},
	{#State 91
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'array' => 105,
			'expr' => 40,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 92
		ACTIONS => {
			"|" => 106
		}
	},
	{#State 93
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			")" => 107,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		}
	},
	{#State 94
		DEFAULT => -3
	},
	{#State 95
		DEFAULT => -25
	},
	{#State 96
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 108,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 97
		DEFAULT => -13
	},
	{#State 98
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 11,
			'argarray' => 109,
			'assignexpr' => 3
		}
	},
	{#State 99
		DEFAULT => -26
	},
	{#State 100
		ACTIONS => {
			'NAME' => 84
		},
		GOTOS => {
			'arglist' => 110,
			'argelement' => 83
		}
	},
	{#State 101
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 111,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 102
		ACTIONS => {
			'NAME' => 112
		}
	},
	{#State 103
		ACTIONS => {
			":=" => 113
		}
	},
	{#State 104
		ACTIONS => {
			"=" => 114
		},
		DEFAULT => -27
	},
	{#State 105
		ACTIONS => {
			"|" => 115
		}
	},
	{#State 106
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 116,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 107
		ACTIONS => {
			"{" => 117
		}
	},
	{#State 108
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -41
	},
	{#State 109
		DEFAULT => -15
	},
	{#State 110
		DEFAULT => -21
	},
	{#State 111
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -19
	},
	{#State 112
		ACTIONS => {
			"=" => 118
		},
		DEFAULT => -18
	},
	{#State 113
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 120,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 119,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 114
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 121,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 115
		DEFAULT => -27
	},
	{#State 116
		ACTIONS => {
			"}" => 122,
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		}
	},
	{#State 117
		ACTIONS => {
			"-" => 1,
			'NAME' => 8,
			"var" => 10,
			'DATE' => 2,
			"{" => 12,
			"while" => 13,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 14,
			'while' => 16,
			'stma' => 123,
			'expr' => 5,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 118
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 2,
			"{" => 12,
			'STRING' => 4,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		GOTOS => {
			'expr' => 124,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 119
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -51
	},
	{#State 120
		ACTIONS => {
			"-" => 1,
			'NAME' => 8,
			"var" => 10,
			'DATE' => 2,
			"{" => 12,
			"while" => 13,
			'STRING' => 4,
			"|" => 54,
			"(" => 15,
			"[" => 6,
			'NUMBER' => 7
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 14,
			'while' => 16,
			'stma' => 125,
			'expr' => 5,
			'exprval' => 11,
			'assignexpr' => 3
		}
	},
	{#State 121
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -55
	},
	{#State 122
		DEFAULT => -54
	},
	{#State 123
		ACTIONS => {
			"}" => 126
		}
	},
	{#State 124
		ACTIONS => {
			"-" => 19,
			"<" => 20,
			"+" => 22,
			"**" => 21,
			"%" => 23,
			"==" => 24,
			">=" => 25,
			"^" => 26,
			" " => 27,
			"*" => 28,
			"per" => 29,
			"!=" => 31,
			"?" => 33,
			"->" => 34,
			"/" => 35,
			"<=" => 37,
			"<=>" => 36,
			">" => 38
		},
		DEFAULT => -17
	},
	{#State 125
		ACTIONS => {
			"}" => 127
		}
	},
	{#State 126
		DEFAULT => -12
	},
	{#State 127
		DEFAULT => -52
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'stma', 0,
sub
#line 26 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 27 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 28 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 32 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 2,
sub
#line 33 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 6
		 'stmt', 2,
sub
#line 34 "Farnsworth.yp"
{ bless [ @{$_[2]} ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 35 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 36 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 37 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 38 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 11
		 'stmt', 1, undef
	],
	[#Rule 12
		 'while', 7,
sub
#line 47 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 13
		 'array', 3,
sub
#line 54 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 14
		 'array', 1,
sub
#line 55 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 15
		 'argarray', 3,
sub
#line 58 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 16
		 'argarray', 1,
sub
#line 59 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 17
		 'argelement', 5,
sub
#line 62 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 18
		 'argelement', 3,
sub
#line 63 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 19
		 'argelement', 3,
sub
#line 64 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 20
		 'argelement', 1,
sub
#line 65 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 21
		 'arglist', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 22
		 'arglist', 1,
sub
#line 69 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 23
		 'exprval', 1,
sub
#line 72 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 24
		 'exprval', 1,
sub
#line 73 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 25
		 'exprval', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 26
		 'exprval', 4,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 27
		 'exprval', 4,
sub
#line 76 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'),$_[3] ], 'ArrayFetch' }
	],
	[#Rule 28
		 'exprval', 2,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 29
		 'assignexpr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 30
		 'expr', 1,
sub
#line 85 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 31
		 'expr', 2,
sub
#line 86 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 87 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 88 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 89 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 90 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 91 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 92 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 93 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 94 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 95 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 41
		 'expr', 5,
sub
#line 96 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 97 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 98 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 99 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 101 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 102 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 48
		 'expr', 3,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 49
		 'expr', 3,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 50
		 'expr', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 51
		 'expr', 6,
sub
#line 106 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 52
		 'expr', 8,
sub
#line 107 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 108 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 54
		 'expr', 6,
sub
#line 109 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 55
		 'expr', 6,
sub
#line 110 "Farnsworth.yp"
{ bless [ @_[1,3,6]], 'ArrayStore' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 57
		 'expr', 1,
sub
#line 112 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 58
		 'expr', 1,
sub
#line 113 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 59
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 116 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	#$s =~ m|\G/\*.*?\*/|gcs and redo; #skip C comments
	#$s =~ s|\G//.*||g;
#	$s =~ s|\G/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;
    $s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1;

    #token out the date
    $s =~ /\G\s*(#[^#]*#)\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*("(\\.|[^"\\])*")/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(while)\b\s*/cg and return $1;

	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /\G\s*(:=|==|!=|<=>|>=|<=|->|:->|\*\*)\s*/icg and return lc $1;
	$s =~ /\G\s*(var\b|per\b|isa\b|\:?\:\-|\=\!\=|\|\|\|)\s*/icg and return lc $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^|=|;|\{|\}|\>|\<|\?|\:|\,|\|)\s*/cg and return $1;
	$s =~ /\G\s*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)\s*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yylexwatch
{
   my @r = &yylex;
   #print Dumper(\@r,[pos $s]);
   #$charcount+=pos $s;
   #$s = substr($s, pos $s);
   return @r;
}

sub yyerror
	{
	my $pos = pos $s;
	substr($fullstring,$pos,0) = '<###YYLEX###>';
	$fullstring =~ s/^/### /mg;
	die "### Syntax Error \@ $pos of\n$fullstring\n";
	}

sub parse
	{
	$charcount=0;
	my $self = shift;
	$s = join ' ', @_;
	$fullstring = $s; #preserve it for errors
	my $code = eval
		{ $self->new(yylex => \&yylexwatch, yyerror => \&yyerror)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
