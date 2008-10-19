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
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			"(" => 24,
			'HEXNUMBER' => 23,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 15,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 25,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 2
		ACTIONS => {
			"|" => 27
		},
		DEFAULT => -47
	},
	{#State 3
		DEFAULT => -85
	},
	{#State 4
		ACTIONS => {
			"=" => 28
		},
		DEFAULT => -48
	},
	{#State 5
		DEFAULT => -87
	},
	{#State 6
		DEFAULT => -86
	},
	{#State 7
		DEFAULT => -12
	},
	{#State 8
		DEFAULT => -46
	},
	{#State 9
		ACTIONS => {
			"(" => 29
		}
	},
	{#State 10
		ACTIONS => {
			'HEXNUMBER' => 23,
			"(" => 24,
			'NAME' => 31,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'exprval' => 32,
			'arrayfetchexpr' => 30
		}
	},
	{#State 11
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			":->" => 45,
			"!=" => 46,
			"|||" => 47,
			"?" => 50,
			"&&" => 49,
			"||" => 48,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -5
	},
	{#State 12
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 58,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 59,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 60,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 13
		DEFAULT => -41
	},
	{#State 14
		ACTIONS => {
			"[" => 61,
			"::-" => 65,
			":=" => 62,
			"=!=" => 64,
			"{" => 63,
			"=" => 66,
			":-" => 67
		},
		DEFAULT => -43
	},
	{#State 15
		ACTIONS => {
			'' => 68
		}
	},
	{#State 16
		ACTIONS => {
			'HEXNUMBER' => 23,
			"(" => 24,
			'NUMBER' => 13,
			'NAME' => 31
		},
		DEFAULT => -51,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'exprval' => 69,
			'arrayfetchexpr' => 30
		}
	},
	{#State 17
		ACTIONS => {
			'NAME' => 71
		},
		GOTOS => {
			'assignexpr' => 70
		}
	},
	{#State 18
		ACTIONS => {
			"|" => 72
		}
	},
	{#State 19
		ACTIONS => {
			"\n" => 73,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 75
		}
	},
	{#State 20
		ACTIONS => {
			"(" => 76
		}
	},
	{#State 21
		ACTIONS => {
			"\n" => 78,
			";" => 77
		},
		DEFAULT => -2
	},
	{#State 22
		DEFAULT => -13
	},
	{#State 23
		DEFAULT => -42
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 79,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 25
		ACTIONS => {
			"**" => 36,
			"^" => 41
		},
		DEFAULT => -52
	},
	{#State 26
		ACTIONS => {
			"[" => 61,
			"::-" => 65,
			"{" => 63,
			"=" => 66,
			":-" => 67
		},
		DEFAULT => -43
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 58,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 80,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 60,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 81,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 82,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 30
		DEFAULT => -48
	},
	{#State 31
		ACTIONS => {
			"[" => 61
		},
		DEFAULT => -43
	},
	{#State 32
		DEFAULT => -68
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 83,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 84,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 85,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 86,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 87,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 88,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 89,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 90,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 91,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 92,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 93,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 94,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 95,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 46
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 96,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 47
		ACTIONS => {
			'NAME' => 97
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 98,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 99,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 100,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 51
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 101,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 52
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 102,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 53
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 103,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 54
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 104,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 55
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 105,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 56
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 106,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 57
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 107,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 58
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 58,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 108,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 60,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 59
		ACTIONS => {
			"]" => 109
		}
	},
	{#State 60
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"," => 110,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"&&" => 49,
			"||" => 48,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -28
	},
	{#State 61
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -33,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 111,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'argarray' => 112,
			'assignexpr' => 5
		}
	},
	{#State 62
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 113,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 63
		ACTIONS => {
			'NAME' => 115
		},
		DEFAULT => -38,
		GOTOS => {
			'arglist' => 116,
			'argelement' => 114
		}
	},
	{#State 64
		ACTIONS => {
			'NAME' => 117
		}
	},
	{#State 65
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 118,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 66
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 119,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 67
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 120,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 68
		DEFAULT => 0
	},
	{#State 69
		DEFAULT => -57
	},
	{#State 70
		DEFAULT => -7
	},
	{#State 71
		ACTIONS => {
			"=" => 66
		},
		DEFAULT => -6
	},
	{#State 72
		ACTIONS => {
			'NAME' => 115
		},
		DEFAULT => -38,
		GOTOS => {
			'arglist' => 121,
			'argelement' => 114
		}
	},
	{#State 73
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 122
		}
	},
	{#State 74
		ACTIONS => {
			"-" => 1,
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 123,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 75
		ACTIONS => {
			"else" => 124
		},
		DEFAULT => -16
	},
	{#State 76
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 126,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 77
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 6,
			"if" => 9,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13,
			'NAME' => 14,
			"var" => 17,
			"{" => 18,
			"while" => 20,
			"(" => 24,
			'HEXNUMBER' => 23
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 127,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 78
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 6,
			"if" => 9,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13,
			'NAME' => 14,
			"var" => 17,
			"{" => 18,
			"while" => 20,
			"(" => 24,
			'HEXNUMBER' => 23
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 128,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			")" => 129,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 80
		ACTIONS => {
			"|" => 130
		}
	},
	{#State 81
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -83
	},
	{#State 82
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			")" => 131,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 83
		ACTIONS => {
			"%" => 38,
			" " => 42,
			"*" => 43,
			"**" => 36,
			"^" => 41,
			"per" => 44,
			"/" => 53
		},
		DEFAULT => -55
	},
	{#State 84
		ACTIONS => {
			"-" => 33,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -63
	},
	{#State 85
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -69
	},
	{#State 86
		DEFAULT => -62
	},
	{#State 87
		ACTIONS => {
			"%" => 38,
			" " => 42,
			"*" => 43,
			"**" => 36,
			"^" => 41,
			"per" => 44,
			"/" => 53
		},
		DEFAULT => -54
	},
	{#State 88
		ACTIONS => {
			"**" => 36,
			"^" => 41
		},
		DEFAULT => -60
	},
	{#State 89
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -73
	},
	{#State 90
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -72
	},
	{#State 91
		DEFAULT => -61
	},
	{#State 92
		ACTIONS => {
			"**" => 36,
			"^" => 41
		},
		DEFAULT => -53
	},
	{#State 93
		ACTIONS => {
			"**" => 36,
			"^" => 41
		},
		DEFAULT => -56
	},
	{#State 94
		ACTIONS => {
			"%" => 38,
			" " => 42,
			"*" => 43,
			"**" => 36,
			"^" => 41,
			"/" => 53
		},
		DEFAULT => -59
	},
	{#State 95
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -9
	},
	{#State 96
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -75
	},
	{#State 97
		DEFAULT => -11
	},
	{#State 98
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -66
	},
	{#State 99
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -65
	},
	{#State 100
		ACTIONS => {
			":" => 132,
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 101
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -67
	},
	{#State 102
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -84
	},
	{#State 103
		ACTIONS => {
			"**" => 36,
			"^" => 41
		},
		DEFAULT => -58
	},
	{#State 104
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -82
	},
	{#State 105
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -74
	},
	{#State 106
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -71
	},
	{#State 107
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"%" => 38,
			"==" => undef,
			">=" => undef,
			" " => 42,
			"*" => 43,
			"<=" => undef,
			">" => undef,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => undef,
			"/" => 53,
			"<=>" => undef
		},
		DEFAULT => -70
	},
	{#State 108
		DEFAULT => -30
	},
	{#State 109
		DEFAULT => -80
	},
	{#State 110
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 58,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 133,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 60,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 111
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"," => 134,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"&&" => 49,
			"||" => 48,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -32
	},
	{#State 112
		ACTIONS => {
			"]" => 135
		}
	},
	{#State 113
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -8
	},
	{#State 114
		ACTIONS => {
			"," => 136
		},
		DEFAULT => -40
	},
	{#State 115
		ACTIONS => {
			"isa" => 138,
			"=" => 137
		},
		DEFAULT => -37
	},
	{#State 116
		ACTIONS => {
			"}" => 139
		}
	},
	{#State 117
		DEFAULT => -10
	},
	{#State 118
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -76
	},
	{#State 119
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -49
	},
	{#State 120
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -77
	},
	{#State 121
		ACTIONS => {
			"|" => 140
		}
	},
	{#State 122
		ACTIONS => {
			"else" => 141
		},
		DEFAULT => -18
	},
	{#State 123
		ACTIONS => {
			"}" => 143
		}
	},
	{#State 124
		ACTIONS => {
			"\n" => 144,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 145
		}
	},
	{#State 125
		ACTIONS => {
			"else" => 146
		}
	},
	{#State 126
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			")" => 147,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 127
		DEFAULT => -3
	},
	{#State 128
		DEFAULT => -4
	},
	{#State 129
		DEFAULT => -44
	},
	{#State 130
		DEFAULT => -50
	},
	{#State 131
		DEFAULT => -14
	},
	{#State 132
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 148,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 133
		DEFAULT => -27
	},
	{#State 134
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -33,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 111,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'argarray' => 149,
			'assignexpr' => 5
		}
	},
	{#State 135
		DEFAULT => -45
	},
	{#State 136
		ACTIONS => {
			'NAME' => 115
		},
		DEFAULT => -38,
		GOTOS => {
			'arglist' => 150,
			'argelement' => 114
		}
	},
	{#State 137
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 151,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 138
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 152,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 139
		ACTIONS => {
			":=" => 153
		}
	},
	{#State 140
		ACTIONS => {
			"-" => 1,
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 154,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 141
		ACTIONS => {
			"\n" => 155,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 156
		}
	},
	{#State 142
		ACTIONS => {
			"else" => 157
		}
	},
	{#State 143
		DEFAULT => -15
	},
	{#State 144
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 158
		}
	},
	{#State 145
		DEFAULT => -17
	},
	{#State 146
		ACTIONS => {
			"\n" => 159,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 160
		}
	},
	{#State 147
		ACTIONS => {
			"{" => 161
		}
	},
	{#State 148
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -64
	},
	{#State 149
		DEFAULT => -31
	},
	{#State 150
		DEFAULT => -39
	},
	{#State 151
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"isa" => 162,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -36
	},
	{#State 152
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -35
	},
	{#State 153
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 164,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 163,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 154
		ACTIONS => {
			"}" => 165
		}
	},
	{#State 155
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 166
		}
	},
	{#State 156
		DEFAULT => -19
	},
	{#State 157
		ACTIONS => {
			"\n" => 167,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 168
		}
	},
	{#State 158
		DEFAULT => -24
	},
	{#State 159
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 169
		}
	},
	{#State 160
		DEFAULT => -23
	},
	{#State 161
		ACTIONS => {
			"-" => 1,
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 170,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 162
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 171,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 163
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"*" => 43,
			"||" => 48,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 36,
			"+" => 37,
			"^" => 41,
			"per" => 44,
			"!=" => 46,
			"&&" => 49,
			"?" => 50,
			"^^" => 51,
			"/" => 53,
			"<=>" => 55
		},
		DEFAULT => -78
	},
	{#State 164
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 6,
			"if" => 9,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13,
			'NAME' => 14,
			"var" => 17,
			"{" => 18,
			"while" => 20,
			"(" => 24,
			'HEXNUMBER' => 23,
			"|" => 72
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 172,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 165
		DEFAULT => -81
	},
	{#State 166
		DEFAULT => -21
	},
	{#State 167
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 173
		}
	},
	{#State 168
		DEFAULT => -20
	},
	{#State 169
		DEFAULT => -25
	},
	{#State 170
		ACTIONS => {
			"}" => 174
		}
	},
	{#State 171
		ACTIONS => {
			"-" => 33,
			"conforms" => 34,
			"<" => 35,
			"+" => 37,
			"**" => 36,
			"%" => 38,
			"==" => 39,
			">=" => 40,
			" " => 42,
			"^" => 41,
			"*" => 43,
			"per" => 44,
			"!=" => 46,
			"?" => 50,
			"||" => 48,
			"&&" => 49,
			"^^" => 51,
			"/" => 53,
			"->" => 52,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -34
	},
	{#State 172
		ACTIONS => {
			"}" => 175
		}
	},
	{#State 173
		DEFAULT => -22
	},
	{#State 174
		DEFAULT => -26
	},
	{#State 175
		DEFAULT => -79
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
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stma', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 5
		 'stmt', 1,
sub
#line 37 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 6
		 'stmt', 2,
sub
#line 38 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 2,
sub
#line 39 "Farnsworth.yp"
{ bless [ @{$_[2]} ], 'DeclareVar' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 40 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 42 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 11
		 'stmt', 3,
sub
#line 43 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 12
		 'stmt', 1, undef
	],
	[#Rule 13
		 'stmt', 1, undef
	],
	[#Rule 14
		 'ifstartcond', 4,
sub
#line 48 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 15
		 'ifstmts', 3,
sub
#line 50 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 16
		 'if', 2,
sub
#line 53 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 17
		 'if', 4,
sub
#line 54 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 18
		 'if', 3,
sub
#line 55 "Farnsworth.yp"
{bless [@_[1,3], undef], 'If'}
	],
	[#Rule 19
		 'if', 5,
sub
#line 56 "Farnsworth.yp"
{bless [@_[1,3,5]], 'If'}
	],
	[#Rule 20
		 'if', 6,
sub
#line 57 "Farnsworth.yp"
{bless [@_[1,3,6]], 'If'}
	],
	[#Rule 21
		 'if', 6,
sub
#line 58 "Farnsworth.yp"
{bless [@_[1,3,6]], 'If'}
	],
	[#Rule 22
		 'if', 7,
sub
#line 59 "Farnsworth.yp"
{bless [@_[1,3,7]], 'If'}
	],
	[#Rule 23
		 'if', 5,
sub
#line 60 "Farnsworth.yp"
{bless [@_[1,2,5]], 'If'}
	],
	[#Rule 24
		 'if', 5,
sub
#line 61 "Farnsworth.yp"
{bless [@_[1,2,5]], 'If'}
	],
	[#Rule 25
		 'if', 6,
sub
#line 62 "Farnsworth.yp"
{bless [@_[1,2,6]], 'If'}
	],
	[#Rule 26
		 'while', 7,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 27
		 'array', 3,
sub
#line 77 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 28
		 'array', 1,
sub
#line 78 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 29
		 'array', 0,
sub
#line 79 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 30
		 'array', 2,
sub
#line 80 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 31
		 'argarray', 3,
sub
#line 83 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 32
		 'argarray', 1,
sub
#line 84 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 33
		 'argarray', 0,
sub
#line 85 "Farnsworth.yp"
{bless [], 'ArgArray'}
	],
	[#Rule 34
		 'argelement', 5,
sub
#line 88 "Farnsworth.yp"
{bless [$_[1], $_[3], $_[5]], 'Argele'}
	],
	[#Rule 35
		 'argelement', 3,
sub
#line 89 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 36
		 'argelement', 3,
sub
#line 90 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 37
		 'argelement', 1,
sub
#line 91 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 38
		 'argelement', 0, undef
	],
	[#Rule 39
		 'arglist', 3,
sub
#line 95 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 40
		 'arglist', 1,
sub
#line 96 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 41
		 'exprval1', 1,
sub
#line 99 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 42
		 'exprval1', 1,
sub
#line 100 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 43
		 'exprval2', 1,
sub
#line 104 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 44
		 'exprval2', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 45
		 'exprval2', 4,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 46
		 'exprval', 1, undef
	],
	[#Rule 47
		 'exprval', 1, undef
	],
	[#Rule 48
		 'exprval', 1, undef
	],
	[#Rule 49
		 'assignexpr', 3,
sub
#line 115 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 50
		 'arrayfetchexpr', 4,
sub
#line 118 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 51
		 'expr', 1,
sub
#line 122 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 52
		 'expr', 2,
sub
#line 123 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 124 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 54
		 'expr', 3,
sub
#line 125 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 55
		 'expr', 3,
sub
#line 126 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 127 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 57
		 'expr', 2,
sub
#line 128 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 129 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 59
		 'expr', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 60
		 'expr', 3,
sub
#line 131 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 61
		 'expr', 3,
sub
#line 132 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 62
		 'expr', 3,
sub
#line 133 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 63
		 'expr', 3,
sub
#line 134 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 64
		 'expr', 5,
sub
#line 135 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 65
		 'expr', 3,
sub
#line 136 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 66
		 'expr', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 67
		 'expr', 3,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 68
		 'expr', 2,
sub
#line 139 "Farnsworth.yp"
{ bless [ @_[2] ], 'Not' }
	],
	[#Rule 69
		 'expr', 3,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 70
		 'expr', 3,
sub
#line 141 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 71
		 'expr', 3,
sub
#line 142 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 72
		 'expr', 3,
sub
#line 143 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 73
		 'expr', 3,
sub
#line 144 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 74
		 'expr', 3,
sub
#line 145 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 75
		 'expr', 3,
sub
#line 146 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 76
		 'expr', 3,
sub
#line 147 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 77
		 'expr', 3,
sub
#line 148 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 78
		 'expr', 6,
sub
#line 149 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 79
		 'expr', 8,
sub
#line 150 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 80
		 'expr', 3,
sub
#line 151 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 81
		 'expr', 6,
sub
#line 152 "Farnsworth.yp"
{bless [ @_[3,5] ], 'Lambda'}
	],
	[#Rule 82
		 'expr', 3,
sub
#line 153 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 83
		 'expr', 3,
sub
#line 154 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 84
		 'expr', 3,
sub
#line 155 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 85
		 'expr', 1,
sub
#line 156 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 86
		 'expr', 1,
sub
#line 157 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 87
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 160 "Farnsworth.yp"


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
	$s =~ /\G(0x[[:xdigit:]]+)/igc and return 'HEXNUMBER', $1;
	$s =~ /\G(0b[01]+)/igc and return 'HEXNUMBER', $1; #binary
	$s =~ /\G(0[0-7]+)/igc and return 'HEXNUMBER', $1; #octal
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
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^\^?|=|;|\n|\{|\}|\>|\<|\?|\:|\,|\&\&|\|\||\!|\|)\s*/cg and return $1;
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
