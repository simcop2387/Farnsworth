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

#line 17 "Farnsworth.yp"

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
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 12,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 20,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 2
		DEFAULT => -67
	},
	{#State 3
		ACTIONS => {
			"=" => 22
		},
		DEFAULT => -34
	},
	{#State 4
		DEFAULT => -69
	},
	{#State 5
		DEFAULT => -68
	},
	{#State 6
		DEFAULT => -11
	},
	{#State 7
		ACTIONS => {
			"(" => 23
		}
	},
	{#State 8
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			":->" => 36,
			"!=" => 37,
			"|||" => 38,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -4
	},
	{#State 9
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			"," => 46,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -18,
		GOTOS => {
			'array' => 47,
			'expr' => 48,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 10
		DEFAULT => -30
	},
	{#State 11
		ACTIONS => {
			"[" => 49,
			"::-" => 53,
			"|" => 55,
			":=" => 50,
			"=!=" => 52,
			"{" => 51,
			"=" => 54,
			":-" => 56
		},
		DEFAULT => -31
	},
	{#State 12
		ACTIONS => {
			'' => 57
		}
	},
	{#State 13
		ACTIONS => {
			'NAME' => 59
		},
		GOTOS => {
			'assignexpr' => 58
		}
	},
	{#State 14
		ACTIONS => {
			"(" => 19,
			'NUMBER' => 10,
			'NAME' => 61
		},
		DEFAULT => -37,
		GOTOS => {
			'exprval' => 62,
			'arrayfetchexpr' => 60
		}
	},
	{#State 15
		ACTIONS => {
			"|" => 63
		}
	},
	{#State 16
		ACTIONS => {
			"(" => 64
		}
	},
	{#State 17
		ACTIONS => {
			";" => 65
		},
		DEFAULT => -2
	},
	{#State 18
		DEFAULT => -12
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 66,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 20
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -38
	},
	{#State 21
		ACTIONS => {
			"[" => 49,
			"::-" => 53,
			"|" => 55,
			"{" => 51,
			"=" => 54,
			":-" => 56
		},
		DEFAULT => -31
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 67,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 68,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 69,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 70,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 71,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 72,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 73,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 74,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 75,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 77,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 78,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 79,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 81,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 82,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 38
		ACTIONS => {
			'NAME' => 83
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 84,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 85,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 86,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 87,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 88,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 89,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 90,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 46
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			"," => 46,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -18,
		GOTOS => {
			'array' => 91,
			'expr' => 48,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 47
		ACTIONS => {
			"]" => 92
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"," => 93,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -17
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -22,
		GOTOS => {
			'expr' => 94,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'argarray' => 95,
			'assignexpr' => 4
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 96,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 51
		ACTIONS => {
			'NAME' => 98
		},
		DEFAULT => -27,
		GOTOS => {
			'arglist' => 99,
			'argelement' => 97
		}
	},
	{#State 52
		ACTIONS => {
			'NAME' => 100
		}
	},
	{#State 53
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 101,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 54
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 102,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 55
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			"," => 46,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -18,
		GOTOS => {
			'array' => 103,
			'expr' => 48,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 56
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 104,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 57
		DEFAULT => 0
	},
	{#State 58
		DEFAULT => -6
	},
	{#State 59
		ACTIONS => {
			"=" => 54
		},
		DEFAULT => -5
	},
	{#State 60
		DEFAULT => -34
	},
	{#State 61
		ACTIONS => {
			"[" => 49,
			"|" => 55
		},
		DEFAULT => -31
	},
	{#State 62
		DEFAULT => -43
	},
	{#State 63
		ACTIONS => {
			'NAME' => 98
		},
		DEFAULT => -27,
		GOTOS => {
			'arglist' => 105,
			'argelement' => 97
		}
	},
	{#State 64
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 106,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 65
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 107,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 66
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			")" => 108,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		}
	},
	{#State 67
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -65
	},
	{#State 68
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			")" => 109,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		}
	},
	{#State 69
		ACTIONS => {
			"%" => 29,
			" " => 33,
			"*" => 34,
			"**" => 27,
			"^" => 32,
			"per" => 35,
			"/" => 41
		},
		DEFAULT => -41
	},
	{#State 70
		ACTIONS => {
			"-" => 24,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -49
	},
	{#State 71
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -51
	},
	{#State 72
		DEFAULT => -48
	},
	{#State 73
		ACTIONS => {
			"%" => 29,
			" " => 33,
			"*" => 34,
			"**" => 27,
			"^" => 32,
			"per" => 35,
			"/" => 41
		},
		DEFAULT => -40
	},
	{#State 74
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -46
	},
	{#State 75
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -55
	},
	{#State 76
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -54
	},
	{#State 77
		DEFAULT => -47
	},
	{#State 78
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -39
	},
	{#State 79
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -42
	},
	{#State 80
		ACTIONS => {
			"%" => 29,
			" " => 33,
			"*" => 34,
			"**" => 27,
			"^" => 32,
			"/" => 41
		},
		DEFAULT => -45
	},
	{#State 81
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -8
	},
	{#State 82
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -57
	},
	{#State 83
		DEFAULT => -10
	},
	{#State 84
		ACTIONS => {
			":" => 110,
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		}
	},
	{#State 85
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -66
	},
	{#State 86
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -44
	},
	{#State 87
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -64
	},
	{#State 88
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -56
	},
	{#State 89
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -53
	},
	{#State 90
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"*" => 34,
			"<=" => undef,
			">" => undef,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=>" => undef
		},
		DEFAULT => -52
	},
	{#State 91
		DEFAULT => -19
	},
	{#State 92
		DEFAULT => -62
	},
	{#State 93
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			"," => 46,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -18,
		GOTOS => {
			'array' => 111,
			'expr' => 48,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 94
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"," => 112,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -21
	},
	{#State 95
		ACTIONS => {
			"]" => 113
		}
	},
	{#State 96
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -7
	},
	{#State 97
		ACTIONS => {
			"," => 114
		},
		DEFAULT => -29
	},
	{#State 98
		ACTIONS => {
			"isa" => 116,
			"=" => 115
		},
		DEFAULT => -26
	},
	{#State 99
		ACTIONS => {
			"}" => 117
		}
	},
	{#State 100
		DEFAULT => -9
	},
	{#State 101
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -58
	},
	{#State 102
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -35
	},
	{#State 103
		ACTIONS => {
			"|" => 118
		}
	},
	{#State 104
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -59
	},
	{#State 105
		ACTIONS => {
			"|" => 119
		}
	},
	{#State 106
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			")" => 120,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		}
	},
	{#State 107
		DEFAULT => -3
	},
	{#State 108
		DEFAULT => -32
	},
	{#State 109
		ACTIONS => {
			"{" => 121
		}
	},
	{#State 110
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 122,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 111
		DEFAULT => -16
	},
	{#State 112
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -22,
		GOTOS => {
			'expr' => 94,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'argarray' => 123,
			'assignexpr' => 4
		}
	},
	{#State 113
		DEFAULT => -33
	},
	{#State 114
		ACTIONS => {
			'NAME' => 98
		},
		DEFAULT => -27,
		GOTOS => {
			'arglist' => 124,
			'argelement' => 97
		}
	},
	{#State 115
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 125,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 116
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 126,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 117
		ACTIONS => {
			":=" => 127
		}
	},
	{#State 118
		DEFAULT => -36
	},
	{#State 119
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 128,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 120
		ACTIONS => {
			"{" => 129
		}
	},
	{#State 121
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 130,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 122
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -50
	},
	{#State 123
		DEFAULT => -20
	},
	{#State 124
		DEFAULT => -28
	},
	{#State 125
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"isa" => 131,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -25
	},
	{#State 126
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -24
	},
	{#State 127
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 133,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 132,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 128
		ACTIONS => {
			"}" => 134
		}
	},
	{#State 129
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 135,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 130
		ACTIONS => {
			"}" => 136
		}
	},
	{#State 131
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 137,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 132
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"*" => 34,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			">" => 45,
			"**" => 27,
			"+" => 28,
			"^" => 32,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"<=>" => 43
		},
		DEFAULT => -60
	},
	{#State 133
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"|" => 63,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 138,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 134
		DEFAULT => -63
	},
	{#State 135
		ACTIONS => {
			"}" => 139
		}
	},
	{#State 136
		ACTIONS => {
			"else" => 140
		},
		DEFAULT => -13
	},
	{#State 137
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -23
	},
	{#State 138
		ACTIONS => {
			"}" => 141
		}
	},
	{#State 139
		DEFAULT => -15
	},
	{#State 140
		ACTIONS => {
			"{" => 142
		}
	},
	{#State 141
		DEFAULT => -61
	},
	{#State 142
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 143,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 143
		ACTIONS => {
			"}" => 144
		}
	},
	{#State 144
		DEFAULT => -14
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
#line 28 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 29 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 30 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 34 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 2,
sub
#line 35 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 6
		 'stmt', 2,
sub
#line 36 "Farnsworth.yp"
{ bless [ @{$_[2]} ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 37 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 38 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 39 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 40 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 11
		 'stmt', 1, undef
	],
	[#Rule 12
		 'stmt', 1, undef
	],
	[#Rule 13
		 'if', 7,
sub
#line 45 "Farnsworth.yp"
{bless [@_[3,6], undef], 'If'}
	],
	[#Rule 14
		 'if', 11,
sub
#line 46 "Farnsworth.yp"
{bless [@_[3,6,10]], 'If'}
	],
	[#Rule 15
		 'while', 7,
sub
#line 54 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 16
		 'array', 3,
sub
#line 61 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 17
		 'array', 1,
sub
#line 62 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 18
		 'array', 0,
sub
#line 63 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 19
		 'array', 2,
sub
#line 64 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 20
		 'argarray', 3,
sub
#line 67 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 21
		 'argarray', 1,
sub
#line 68 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 22
		 'argarray', 0,
sub
#line 69 "Farnsworth.yp"
{bless [], 'ArgArray'}
	],
	[#Rule 23
		 'argelement', 5,
sub
#line 72 "Farnsworth.yp"
{bless [$_[1], $_[3], $_[5]], 'Argele'}
	],
	[#Rule 24
		 'argelement', 3,
sub
#line 73 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 25
		 'argelement', 3,
sub
#line 74 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 26
		 'argelement', 1,
sub
#line 75 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 27
		 'argelement', 0, undef
	],
	[#Rule 28
		 'arglist', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 29
		 'arglist', 1,
sub
#line 80 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 30
		 'exprval', 1,
sub
#line 83 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 31
		 'exprval', 1,
sub
#line 84 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 32
		 'exprval', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 33
		 'exprval', 4,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 34
		 'exprval', 1, undef
	],
	[#Rule 35
		 'assignexpr', 3,
sub
#line 91 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 36
		 'arrayfetchexpr', 4,
sub
#line 94 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'),$_[3] ], 'ArrayFetch' }
	],
	[#Rule 37
		 'expr', 1,
sub
#line 98 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 38
		 'expr', 2,
sub
#line 99 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 101 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 102 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 43
		 'expr', 2,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 107 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 108 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 48
		 'expr', 3,
sub
#line 109 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 49
		 'expr', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 50
		 'expr', 5,
sub
#line 111 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 51
		 'expr', 3,
sub
#line 112 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 113 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 114 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 54
		 'expr', 3,
sub
#line 115 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 55
		 'expr', 3,
sub
#line 116 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 57
		 'expr', 3,
sub
#line 118 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 59
		 'expr', 3,
sub
#line 120 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 60
		 'expr', 6,
sub
#line 121 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 61
		 'expr', 8,
sub
#line 122 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 62
		 'expr', 3,
sub
#line 123 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 63
		 'expr', 6,
sub
#line 124 "Farnsworth.yp"
{bless [ @_[3,5] ], 'Lambda'}
	],
	[#Rule 64
		 'expr', 3,
sub
#line 125 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 65
		 'expr', 3,
sub
#line 126 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 66
		 'expr', 3,
sub
#line 127 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 67
		 'expr', 1,
sub
#line 128 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 68
		 'expr', 1,
sub
#line 129 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 69
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 132 "Farnsworth.yp"


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
