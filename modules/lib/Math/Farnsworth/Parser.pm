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

#line 16 "Farnsworth.yp"

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
			'NAME' => 9,
			"var" => 11,
			'DATE' => 2,
			"{" => 13,
			"while" => 14,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 15,
			'while' => 17,
			'stma' => 10,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 18,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 2
		DEFAULT => -60
	},
	{#State 3
		ACTIONS => {
			"=" => 20
		},
		DEFAULT => -29
	},
	{#State 4
		DEFAULT => -62
	},
	{#State 5
		DEFAULT => -61
	},
	{#State 6
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			":->" => 32,
			"!=" => 33,
			"|||" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -4
	},
	{#State 7
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -15,
		GOTOS => {
			'array' => 41,
			'expr' => 42,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 8
		DEFAULT => -25
	},
	{#State 9
		ACTIONS => {
			"[" => 43,
			"::-" => 47,
			"|" => 49,
			":=" => 44,
			"=!=" => 46,
			"{" => 45,
			"=" => 48,
			":-" => 50
		},
		DEFAULT => -26
	},
	{#State 10
		ACTIONS => {
			'' => 51
		}
	},
	{#State 11
		ACTIONS => {
			'NAME' => 53
		},
		GOTOS => {
			'assignexpr' => 52
		}
	},
	{#State 12
		ACTIONS => {
			"(" => 16,
			'NUMBER' => 8,
			'NAME' => 55
		},
		DEFAULT => -33,
		GOTOS => {
			'exprval' => 56,
			'arrayfetchexpr' => 54
		}
	},
	{#State 13
		ACTIONS => {
			"|" => 57
		}
	},
	{#State 14
		ACTIONS => {
			"(" => 58
		}
	},
	{#State 15
		ACTIONS => {
			";" => 59
		},
		DEFAULT => -2
	},
	{#State 16
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 60,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 17
		DEFAULT => -11
	},
	{#State 18
		ACTIONS => {
			"**" => 23,
			"^" => 28
		},
		DEFAULT => -34
	},
	{#State 19
		ACTIONS => {
			"[" => 43,
			"::-" => 47,
			"|" => 49,
			"{" => 45,
			"=" => 48,
			":-" => 50
		},
		DEFAULT => -26
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 61,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 21
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 62,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 63,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 64,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 65,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 66,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 67,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 68,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 69,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 70,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 71,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 72,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 73,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 74,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 34
		ACTIONS => {
			'NAME' => 75
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 77,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 78,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 79,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 81,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 41
		ACTIONS => {
			"]" => 82
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"," => 83,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -14
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 84,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'argarray' => 85,
			'assignexpr' => 4
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 86,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 45
		ACTIONS => {
			'NAME' => 88
		},
		DEFAULT => -24,
		GOTOS => {
			'arglist' => 89,
			'argelement' => 87
		}
	},
	{#State 46
		ACTIONS => {
			'NAME' => 90
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 91,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 92,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -15,
		GOTOS => {
			'array' => 93,
			'expr' => 42,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 94,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 51
		DEFAULT => 0
	},
	{#State 52
		DEFAULT => -6
	},
	{#State 53
		ACTIONS => {
			"=" => 48
		},
		DEFAULT => -5
	},
	{#State 54
		DEFAULT => -29
	},
	{#State 55
		ACTIONS => {
			"[" => 43,
			"|" => 49
		},
		DEFAULT => -26
	},
	{#State 56
		ACTIONS => {
			"(" => 16,
			'NUMBER' => 8,
			'NAME' => 55
		},
		DEFAULT => -30,
		GOTOS => {
			'exprval' => 56,
			'arrayfetchexpr' => 54
		}
	},
	{#State 57
		ACTIONS => {
			'NAME' => 88
		},
		DEFAULT => -24,
		GOTOS => {
			'arglist' => 95,
			'argelement' => 87
		}
	},
	{#State 58
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 96,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 59
		ACTIONS => {
			"-" => 1,
			'NAME' => 9,
			"var" => 11,
			'DATE' => 2,
			"{" => 13,
			"while" => 14,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 15,
			'while' => 17,
			'stma' => 97,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 60
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			")" => 98,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		}
	},
	{#State 61
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -58
	},
	{#State 62
		ACTIONS => {
			"**" => 23,
			"%" => 25,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"/" => 37
		},
		DEFAULT => -37
	},
	{#State 63
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -45
	},
	{#State 64
		DEFAULT => -43
	},
	{#State 65
		ACTIONS => {
			"**" => 23,
			"%" => 25,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"/" => 37
		},
		DEFAULT => -36
	},
	{#State 66
		ACTIONS => {
			"**" => 23,
			"^" => 28
		},
		DEFAULT => -41
	},
	{#State 67
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -49
	},
	{#State 68
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -48
	},
	{#State 69
		DEFAULT => -42
	},
	{#State 70
		ACTIONS => {
			"**" => 23,
			"^" => 28
		},
		DEFAULT => -35
	},
	{#State 71
		ACTIONS => {
			"**" => 23,
			"^" => 28
		},
		DEFAULT => -38
	},
	{#State 72
		ACTIONS => {
			"**" => 23,
			"%" => 25,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"/" => 37
		},
		DEFAULT => -40
	},
	{#State 73
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -8
	},
	{#State 74
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -51
	},
	{#State 75
		DEFAULT => -10
	},
	{#State 76
		ACTIONS => {
			":" => 99,
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		}
	},
	{#State 77
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -59
	},
	{#State 78
		ACTIONS => {
			"**" => 23,
			"^" => 28
		},
		DEFAULT => -39
	},
	{#State 79
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -50
	},
	{#State 80
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -47
	},
	{#State 81
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => undef,
			">=" => undef,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -46
	},
	{#State 82
		DEFAULT => -56
	},
	{#State 83
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -15,
		GOTOS => {
			'array' => 100,
			'expr' => 42,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 84
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"," => 101,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -17
	},
	{#State 85
		ACTIONS => {
			"]" => 102
		}
	},
	{#State 86
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -7
	},
	{#State 87
		ACTIONS => {
			"," => 103
		},
		DEFAULT => -23
	},
	{#State 88
		ACTIONS => {
			"isa" => 105,
			"=" => 104
		},
		DEFAULT => -21
	},
	{#State 89
		ACTIONS => {
			"}" => 106
		}
	},
	{#State 90
		DEFAULT => -9
	},
	{#State 91
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -52
	},
	{#State 92
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -31
	},
	{#State 93
		ACTIONS => {
			"|" => 107
		}
	},
	{#State 94
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -53
	},
	{#State 95
		ACTIONS => {
			"|" => 108
		}
	},
	{#State 96
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			")" => 109,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		}
	},
	{#State 97
		DEFAULT => -3
	},
	{#State 98
		DEFAULT => -27
	},
	{#State 99
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 110,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 100
		DEFAULT => -13
	},
	{#State 101
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 84,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'argarray' => 111,
			'assignexpr' => 4
		}
	},
	{#State 102
		DEFAULT => -28
	},
	{#State 103
		ACTIONS => {
			'NAME' => 88
		},
		DEFAULT => -24,
		GOTOS => {
			'arglist' => 112,
			'argelement' => 87
		}
	},
	{#State 104
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 113,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 105
		ACTIONS => {
			'NAME' => 114
		}
	},
	{#State 106
		ACTIONS => {
			":=" => 115
		}
	},
	{#State 107
		DEFAULT => -32
	},
	{#State 108
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 116,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 109
		ACTIONS => {
			"{" => 117
		}
	},
	{#State 110
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -44
	},
	{#State 111
		DEFAULT => -16
	},
	{#State 112
		DEFAULT => -22
	},
	{#State 113
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -20
	},
	{#State 114
		ACTIONS => {
			"=" => 118
		},
		DEFAULT => -19
	},
	{#State 115
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 120,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 119,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 116
		ACTIONS => {
			"}" => 121,
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		}
	},
	{#State 117
		ACTIONS => {
			"-" => 1,
			'NAME' => 9,
			"var" => 11,
			'DATE' => 2,
			"{" => 13,
			"while" => 14,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 15,
			'while' => 17,
			'stma' => 122,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 118
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 13,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 123,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 119
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -54
	},
	{#State 120
		ACTIONS => {
			"-" => 1,
			'NAME' => 9,
			"var" => 11,
			'DATE' => 2,
			"{" => 13,
			"while" => 14,
			'STRING' => 5,
			"|" => 57,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 15,
			'while' => 17,
			'stma' => 124,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 121
		DEFAULT => -57
	},
	{#State 122
		ACTIONS => {
			"}" => 125
		}
	},
	{#State 123
		ACTIONS => {
			"-" => 21,
			"<" => 22,
			"+" => 24,
			"**" => 23,
			"%" => 25,
			"==" => 26,
			">=" => 27,
			"^" => 28,
			" " => 29,
			"*" => 30,
			"per" => 31,
			"!=" => 33,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 39,
			"<=>" => 38,
			">" => 40
		},
		DEFAULT => -18
	},
	{#State 124
		ACTIONS => {
			"}" => 126
		}
	},
	{#State 125
		DEFAULT => -12
	},
	{#State 126
		DEFAULT => -55
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
#line 27 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 28 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 29 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 33 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 2,
sub
#line 34 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 6
		 'stmt', 2,
sub
#line 35 "Farnsworth.yp"
{ bless [ @{$_[2]} ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 36 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 37 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 38 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 39 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 11
		 'stmt', 1, undef
	],
	[#Rule 12
		 'while', 7,
sub
#line 48 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 13
		 'array', 3,
sub
#line 55 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 14
		 'array', 1,
sub
#line 56 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 15
		 'array', 0, undef
	],
	[#Rule 16
		 'argarray', 3,
sub
#line 60 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 17
		 'argarray', 1,
sub
#line 61 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 18
		 'argelement', 5,
sub
#line 64 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 19
		 'argelement', 3,
sub
#line 65 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 20
		 'argelement', 3,
sub
#line 66 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 21
		 'argelement', 1,
sub
#line 67 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 22
		 'arglist', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 23
		 'arglist', 1,
sub
#line 71 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 24
		 'arglist', 0, undef
	],
	[#Rule 25
		 'exprval', 1,
sub
#line 75 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 26
		 'exprval', 1,
sub
#line 76 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 27
		 'exprval', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 28
		 'exprval', 4,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 29
		 'exprval', 1, undef
	],
	[#Rule 30
		 'exprval', 2,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 31
		 'assignexpr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 32
		 'arrayfetchexpr', 4,
sub
#line 87 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'),$_[3] ], 'ArrayFetch' }
	],
	[#Rule 33
		 'expr', 1,
sub
#line 91 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 34
		 'expr', 2,
sub
#line 92 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 93 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 94 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 95 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 96 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 97 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 98 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 99 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 101 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 44
		 'expr', 5,
sub
#line 102 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 48
		 'expr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 49
		 'expr', 3,
sub
#line 107 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 50
		 'expr', 3,
sub
#line 108 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 51
		 'expr', 3,
sub
#line 109 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 54
		 'expr', 6,
sub
#line 112 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 55
		 'expr', 8,
sub
#line 113 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 114 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 57
		 'expr', 6,
sub
#line 115 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 58
		 'expr', 3,
sub
#line 116 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 59
		 'expr', 3,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 60
		 'expr', 1,
sub
#line 118 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 61
		 'expr', 1,
sub
#line 119 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 62
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 122 "Farnsworth.yp"


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
   print Dumper(\@r,[pos $s]);
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
		{ $self->new(yylex => \&yylexwatch, yyerror => \&yyerror, yydebug=>0x1F)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
