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

#line 19 "Farnsworth.yp"

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
			'NAME' => 12,
			"var" => 15,
			"\n" => 14,
			'DATE' => 2,
			"{" => 17,
			"while" => 19,
			'STRING' => 5,
			"if" => 7,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 13,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 23,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 2
		DEFAULT => -82
	},
	{#State 3
		ACTIONS => {
			"=" => 25
		},
		DEFAULT => -46
	},
	{#State 4
		DEFAULT => -84
	},
	{#State 5
		DEFAULT => -83
	},
	{#State 6
		DEFAULT => -13
	},
	{#State 7
		ACTIONS => {
			"(" => 26
		}
	},
	{#State 8
		ACTIONS => {
			"(" => 22,
			'NAME' => 28,
			'NUMBER' => 11
		},
		GOTOS => {
			'exprval' => 29,
			'arrayfetchexpr' => 27
		}
	},
	{#State 9
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			":->" => 42,
			"!=" => 43,
			"|||" => 44,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -6
	},
	{#State 10
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			"," => 52,
			'STRING' => 5,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -30,
		GOTOS => {
			'array' => 53,
			'expr' => 54,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 11
		DEFAULT => -42
	},
	{#State 12
		ACTIONS => {
			"[" => 55,
			"::-" => 59,
			"|" => 61,
			":=" => 56,
			"=!=" => 58,
			"{" => 57,
			"=" => 60,
			":-" => 62
		},
		DEFAULT => -43
	},
	{#State 13
		ACTIONS => {
			'' => 63
		}
	},
	{#State 14
		DEFAULT => -2
	},
	{#State 15
		ACTIONS => {
			'NAME' => 65
		},
		GOTOS => {
			'assignexpr' => 64
		}
	},
	{#State 16
		ACTIONS => {
			"||" => 66,
			"(" => 22,
			'NUMBER' => 11,
			'NAME' => 28,
			"&&" => 67
		},
		DEFAULT => -49,
		GOTOS => {
			'exprval' => 68,
			'arrayfetchexpr' => 27
		}
	},
	{#State 17
		ACTIONS => {
			"|" => 69
		}
	},
	{#State 18
		ACTIONS => {
			"\n" => 70,
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 72
		}
	},
	{#State 19
		ACTIONS => {
			"(" => 73
		}
	},
	{#State 20
		ACTIONS => {
			"\n" => 75,
			";" => 74
		},
		DEFAULT => -3
	},
	{#State 21
		DEFAULT => -14
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 23
		ACTIONS => {
			"**" => 33,
			"^" => 38
		},
		DEFAULT => -50
	},
	{#State 24
		ACTIONS => {
			"[" => 55,
			"::-" => 59,
			"|" => 61,
			"{" => 57,
			"=" => 60,
			":-" => 62
		},
		DEFAULT => -43
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 77,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 78,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 27
		DEFAULT => -46
	},
	{#State 28
		ACTIONS => {
			"[" => 55,
			"|" => 61
		},
		DEFAULT => -43
	},
	{#State 29
		DEFAULT => -65
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 79,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 81,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 82,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 83,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 84,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 85,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 86,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 87,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 88,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 89,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 90,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 91,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 92,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 44
		ACTIONS => {
			'NAME' => 93
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 94,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 46
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 95,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 96,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 97,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 98,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 99,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 51
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 100,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 52
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			"," => 52,
			'STRING' => 5,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -30,
		GOTOS => {
			'array' => 101,
			'expr' => 54,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 53
		ACTIONS => {
			"]" => 102
		}
	},
	{#State 54
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"," => 103,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -29
	},
	{#State 55
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -34,
		GOTOS => {
			'expr' => 104,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'argarray' => 105,
			'assignexpr' => 4
		}
	},
	{#State 56
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 106,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 57
		ACTIONS => {
			'NAME' => 108
		},
		DEFAULT => -39,
		GOTOS => {
			'arglist' => 109,
			'argelement' => 107
		}
	},
	{#State 58
		ACTIONS => {
			'NAME' => 110
		}
	},
	{#State 59
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 111,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 60
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 112,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 61
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			"," => 52,
			'STRING' => 5,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -30,
		GOTOS => {
			'array' => 113,
			'expr' => 54,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 62
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 114,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 63
		DEFAULT => 0
	},
	{#State 64
		DEFAULT => -8
	},
	{#State 65
		ACTIONS => {
			"=" => 60
		},
		DEFAULT => -7
	},
	{#State 66
		ACTIONS => {
			"(" => 22,
			'NAME' => 28,
			'NUMBER' => 11
		},
		GOTOS => {
			'exprval' => 115,
			'arrayfetchexpr' => 27
		}
	},
	{#State 67
		ACTIONS => {
			"(" => 22,
			'NAME' => 28,
			'NUMBER' => 11
		},
		GOTOS => {
			'exprval' => 116,
			'arrayfetchexpr' => 27
		}
	},
	{#State 68
		DEFAULT => -55
	},
	{#State 69
		ACTIONS => {
			'NAME' => 108
		},
		DEFAULT => -39,
		GOTOS => {
			'arglist' => 117,
			'argelement' => 107
		}
	},
	{#State 70
		ACTIONS => {
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 118
		}
	},
	{#State 71
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			"\n" => 14,
			"var" => 15,
			'DATE' => 2,
			"{" => 17,
			"while" => 19,
			'STRING' => 5,
			"if" => 7,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 119,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 72
		ACTIONS => {
			"\n" => 121,
			"else" => 120
		},
		DEFAULT => -17
	},
	{#State 73
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 122,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 74
		ACTIONS => {
			"-" => 1,
			'DATE' => 2,
			'STRING' => 5,
			"if" => 7,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11,
			'NAME' => 12,
			"var" => 15,
			"\n" => 14,
			"{" => 17,
			"while" => 19,
			"(" => 22
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 123,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 75
		ACTIONS => {
			"-" => 1,
			'DATE' => 2,
			'STRING' => 5,
			"if" => 7,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11,
			'NAME' => 12,
			"var" => 15,
			"\n" => 14,
			"{" => 17,
			"while" => 19,
			"(" => 22
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 124,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 76
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			")" => 125,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		}
	},
	{#State 77
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -80
	},
	{#State 78
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			")" => 126,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		}
	},
	{#State 79
		ACTIONS => {
			"%" => 35,
			" " => 39,
			"*" => 40,
			"**" => 33,
			"^" => 38,
			"per" => 41,
			"/" => 47
		},
		DEFAULT => -53
	},
	{#State 80
		ACTIONS => {
			"-" => 30,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -61
	},
	{#State 81
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -66
	},
	{#State 82
		DEFAULT => -60
	},
	{#State 83
		ACTIONS => {
			"%" => 35,
			" " => 39,
			"*" => 40,
			"**" => 33,
			"^" => 38,
			"per" => 41,
			"/" => 47
		},
		DEFAULT => -52
	},
	{#State 84
		ACTIONS => {
			"**" => 33,
			"^" => 38
		},
		DEFAULT => -58
	},
	{#State 85
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -70
	},
	{#State 86
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -69
	},
	{#State 87
		DEFAULT => -59
	},
	{#State 88
		ACTIONS => {
			"**" => 33,
			"^" => 38
		},
		DEFAULT => -51
	},
	{#State 89
		ACTIONS => {
			"**" => 33,
			"^" => 38
		},
		DEFAULT => -54
	},
	{#State 90
		ACTIONS => {
			"%" => 35,
			" " => 39,
			"*" => 40,
			"**" => 33,
			"^" => 38,
			"/" => 47
		},
		DEFAULT => -57
	},
	{#State 91
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -10
	},
	{#State 92
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -72
	},
	{#State 93
		DEFAULT => -12
	},
	{#State 94
		ACTIONS => {
			":" => 127,
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		}
	},
	{#State 95
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -81
	},
	{#State 96
		ACTIONS => {
			"**" => 33,
			"^" => 38
		},
		DEFAULT => -56
	},
	{#State 97
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -79
	},
	{#State 98
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -71
	},
	{#State 99
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -68
	},
	{#State 100
		ACTIONS => {
			"-" => 30,
			"<" => undef,
			"%" => 35,
			"==" => undef,
			">=" => undef,
			" " => 39,
			"*" => 40,
			"<=" => undef,
			">" => undef,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => undef,
			"/" => 47,
			"<=>" => undef
		},
		DEFAULT => -67
	},
	{#State 101
		DEFAULT => -31
	},
	{#State 102
		DEFAULT => -77
	},
	{#State 103
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			"," => 52,
			'STRING' => 5,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -30,
		GOTOS => {
			'array' => 128,
			'expr' => 54,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 104
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"," => 129,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -33
	},
	{#State 105
		ACTIONS => {
			"]" => 130
		}
	},
	{#State 106
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -9
	},
	{#State 107
		ACTIONS => {
			"," => 131
		},
		DEFAULT => -41
	},
	{#State 108
		ACTIONS => {
			"isa" => 133,
			"=" => 132
		},
		DEFAULT => -38
	},
	{#State 109
		ACTIONS => {
			"}" => 134
		}
	},
	{#State 110
		DEFAULT => -11
	},
	{#State 111
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -73
	},
	{#State 112
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -47
	},
	{#State 113
		ACTIONS => {
			"|" => 135
		}
	},
	{#State 114
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -74
	},
	{#State 115
		DEFAULT => -64
	},
	{#State 116
		DEFAULT => -63
	},
	{#State 117
		ACTIONS => {
			"|" => 136
		}
	},
	{#State 118
		ACTIONS => {
			"\n" => 138,
			"else" => 137
		},
		DEFAULT => -19
	},
	{#State 119
		ACTIONS => {
			"}" => 139
		}
	},
	{#State 120
		ACTIONS => {
			"\n" => 140,
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 141
		}
	},
	{#State 121
		ACTIONS => {
			"else" => 142
		}
	},
	{#State 122
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			")" => 143,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		}
	},
	{#State 123
		DEFAULT => -4
	},
	{#State 124
		DEFAULT => -5
	},
	{#State 125
		DEFAULT => -44
	},
	{#State 126
		DEFAULT => -15
	},
	{#State 127
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 144,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 128
		DEFAULT => -28
	},
	{#State 129
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -34,
		GOTOS => {
			'expr' => 104,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'argarray' => 145,
			'assignexpr' => 4
		}
	},
	{#State 130
		DEFAULT => -45
	},
	{#State 131
		ACTIONS => {
			'NAME' => 108
		},
		DEFAULT => -39,
		GOTOS => {
			'arglist' => 146,
			'argelement' => 107
		}
	},
	{#State 132
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 147,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 133
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 148,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 134
		ACTIONS => {
			":=" => 149
		}
	},
	{#State 135
		DEFAULT => -48
	},
	{#State 136
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			"\n" => 14,
			"var" => 15,
			'DATE' => 2,
			"{" => 17,
			"while" => 19,
			'STRING' => 5,
			"if" => 7,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 150,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 137
		ACTIONS => {
			"\n" => 151,
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 152
		}
	},
	{#State 138
		ACTIONS => {
			"else" => 153
		}
	},
	{#State 139
		DEFAULT => -16
	},
	{#State 140
		ACTIONS => {
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 154
		}
	},
	{#State 141
		DEFAULT => -18
	},
	{#State 142
		ACTIONS => {
			"\n" => 155,
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 156
		}
	},
	{#State 143
		ACTIONS => {
			"{" => 157
		}
	},
	{#State 144
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -62
	},
	{#State 145
		DEFAULT => -32
	},
	{#State 146
		DEFAULT => -40
	},
	{#State 147
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"isa" => 158,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -37
	},
	{#State 148
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -36
	},
	{#State 149
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 160,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 159,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 150
		ACTIONS => {
			"}" => 161
		}
	},
	{#State 151
		ACTIONS => {
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 162
		}
	},
	{#State 152
		DEFAULT => -20
	},
	{#State 153
		ACTIONS => {
			"\n" => 163,
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 164
		}
	},
	{#State 154
		DEFAULT => -25
	},
	{#State 155
		ACTIONS => {
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 165
		}
	},
	{#State 156
		DEFAULT => -24
	},
	{#State 157
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			"\n" => 14,
			"var" => 15,
			'DATE' => 2,
			"{" => 17,
			"while" => 19,
			'STRING' => 5,
			"if" => 7,
			"(" => 22,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 166,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 158
		ACTIONS => {
			"-" => 1,
			'NAME' => 24,
			'DATE' => 2,
			"{" => 17,
			'STRING' => 5,
			"!" => 8,
			"(" => 22,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 167,
			'exprval' => 16,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 159
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"*" => 40,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			">" => 51,
			"**" => 33,
			"+" => 34,
			"^" => 38,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"<=>" => 49
		},
		DEFAULT => -75
	},
	{#State 160
		ACTIONS => {
			"-" => 1,
			'DATE' => 2,
			'STRING' => 5,
			"if" => 7,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 11,
			'NAME' => 12,
			"var" => 15,
			"\n" => 14,
			"{" => 17,
			"while" => 19,
			"(" => 22,
			"|" => 69
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 21,
			'stma' => 168,
			'expr' => 9,
			'exprval' => 16,
			'ifstartcond' => 18,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 161
		DEFAULT => -78
	},
	{#State 162
		DEFAULT => -22
	},
	{#State 163
		ACTIONS => {
			"{" => 71
		},
		GOTOS => {
			'ifstmts' => 169
		}
	},
	{#State 164
		DEFAULT => -21
	},
	{#State 165
		DEFAULT => -26
	},
	{#State 166
		ACTIONS => {
			"}" => 170
		}
	},
	{#State 167
		ACTIONS => {
			"-" => 30,
			"conforms" => 31,
			"<" => 32,
			"+" => 34,
			"**" => 33,
			"%" => 35,
			"==" => 36,
			">=" => 37,
			" " => 39,
			"^" => 38,
			"*" => 40,
			"per" => 41,
			"!=" => 43,
			"?" => 45,
			"/" => 47,
			"->" => 46,
			"=>" => 48,
			"<=" => 50,
			"<=>" => 49,
			">" => 51
		},
		DEFAULT => -35
	},
	{#State 168
		ACTIONS => {
			"}" => 171
		}
	},
	{#State 169
		DEFAULT => -23
	},
	{#State 170
		DEFAULT => -27
	},
	{#State 171
		DEFAULT => -76
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
#line 30 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 31 "Farnsworth.yp"
{undef}
	],
	[#Rule 3
		 'stma', 1,
sub
#line 32 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 4
		 'stma', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 5
		 'stma', 3,
sub
#line 34 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 6
		 'stmt', 1,
sub
#line 38 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 7
		 'stmt', 2,
sub
#line 39 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 8
		 'stmt', 2,
sub
#line 40 "Farnsworth.yp"
{ bless [ @{$_[2]} ], 'DeclareVar' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 42 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 11
		 'stmt', 3,
sub
#line 43 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 12
		 'stmt', 3,
sub
#line 44 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 13
		 'stmt', 1, undef
	],
	[#Rule 14
		 'stmt', 1, undef
	],
	[#Rule 15
		 'ifstartcond', 4,
sub
#line 49 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 16
		 'ifstmts', 3,
sub
#line 51 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 17
		 'if', 2,
sub
#line 54 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 18
		 'if', 4,
sub
#line 55 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 19
		 'if', 3,
sub
#line 56 "Farnsworth.yp"
{bless [@_[1,3], undef], 'If'}
	],
	[#Rule 20
		 'if', 5,
sub
#line 57 "Farnsworth.yp"
{bless [@_[1,3,5]], 'If'}
	],
	[#Rule 21
		 'if', 6,
sub
#line 58 "Farnsworth.yp"
{bless [@_[1,3,6]], 'If'}
	],
	[#Rule 22
		 'if', 6,
sub
#line 59 "Farnsworth.yp"
{bless [@_[1,3,6]], 'If'}
	],
	[#Rule 23
		 'if', 7,
sub
#line 60 "Farnsworth.yp"
{bless [@_[1,3,7]], 'If'}
	],
	[#Rule 24
		 'if', 5,
sub
#line 61 "Farnsworth.yp"
{bless [@_[1,2,5]], 'If'}
	],
	[#Rule 25
		 'if', 5,
sub
#line 62 "Farnsworth.yp"
{bless [@_[1,2,5]], 'If'}
	],
	[#Rule 26
		 'if', 6,
sub
#line 63 "Farnsworth.yp"
{bless [@_[1,2,6]], 'If'}
	],
	[#Rule 27
		 'while', 7,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 28
		 'array', 3,
sub
#line 78 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 29
		 'array', 1,
sub
#line 79 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 30
		 'array', 0,
sub
#line 80 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 31
		 'array', 2,
sub
#line 81 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 32
		 'argarray', 3,
sub
#line 84 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 33
		 'argarray', 1,
sub
#line 85 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 34
		 'argarray', 0,
sub
#line 86 "Farnsworth.yp"
{bless [], 'ArgArray'}
	],
	[#Rule 35
		 'argelement', 5,
sub
#line 89 "Farnsworth.yp"
{bless [$_[1], $_[3], $_[5]], 'Argele'}
	],
	[#Rule 36
		 'argelement', 3,
sub
#line 90 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 37
		 'argelement', 3,
sub
#line 91 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 38
		 'argelement', 1,
sub
#line 92 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 39
		 'argelement', 0, undef
	],
	[#Rule 40
		 'arglist', 3,
sub
#line 96 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 41
		 'arglist', 1,
sub
#line 97 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 42
		 'exprval', 1,
sub
#line 100 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 43
		 'exprval', 1,
sub
#line 101 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 44
		 'exprval', 3,
sub
#line 102 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 45
		 'exprval', 4,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 46
		 'exprval', 1, undef
	],
	[#Rule 47
		 'assignexpr', 3,
sub
#line 108 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 48
		 'arrayfetchexpr', 4,
sub
#line 111 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'),$_[3] ], 'ArrayFetch' }
	],
	[#Rule 49
		 'expr', 1,
sub
#line 115 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 50
		 'expr', 2,
sub
#line 116 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 51
		 'expr', 3,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 118 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 54
		 'expr', 3,
sub
#line 120 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 55
		 'expr', 2,
sub
#line 121 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 122 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 57
		 'expr', 3,
sub
#line 123 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 124 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 59
		 'expr', 3,
sub
#line 125 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 60
		 'expr', 3,
sub
#line 126 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 61
		 'expr', 3,
sub
#line 127 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 62
		 'expr', 5,
sub
#line 128 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 63
		 'expr', 3,
sub
#line 129 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 64
		 'expr', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 65
		 'expr', 2,
sub
#line 131 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Not' }
	],
	[#Rule 66
		 'expr', 3,
sub
#line 132 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 67
		 'expr', 3,
sub
#line 133 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 68
		 'expr', 3,
sub
#line 134 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 69
		 'expr', 3,
sub
#line 135 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 70
		 'expr', 3,
sub
#line 136 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 71
		 'expr', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 72
		 'expr', 3,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 73
		 'expr', 3,
sub
#line 139 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 74
		 'expr', 3,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 75
		 'expr', 6,
sub
#line 141 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 76
		 'expr', 8,
sub
#line 142 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 77
		 'expr', 3,
sub
#line 143 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 78
		 'expr', 6,
sub
#line 144 "Farnsworth.yp"
{bless [ @_[3,5] ], 'Lambda'}
	],
	[#Rule 79
		 'expr', 3,
sub
#line 145 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 80
		 'expr', 3,
sub
#line 146 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 81
		 'expr', 3,
sub
#line 147 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 82
		 'expr', 1,
sub
#line 148 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 83
		 'expr', 1,
sub
#line 149 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 84
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 152 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G\s*/\*.*?\*/\s*|gcs and redo; #skip C comments
	$s =~ m|\G\s*//.*|gc and redo;
#	$s =~ s|\G/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;
    $s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1;

    #token out the date
    $s =~ /\G\s*#([^#]*)#\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*("(\\.|[^"\\])*")/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(while|conforms|else|if)\b\s*/cg and return $1;

	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /\G\s*(:=|==|!=|<=>|>=|<=|=>|->|:->|\*\*)\s*/icg and return lc $1;
	$s =~ /\G\s*(var\b|per\b|isa\b|\:?\:\-|\=\!\=|\|\|\|)\s*/icg and return lc $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^|=|;|\n|\{|\}|\>|\<|\?|\:|\,|\||\&\&|\|\||\!)\s*/cg and return $1;
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
