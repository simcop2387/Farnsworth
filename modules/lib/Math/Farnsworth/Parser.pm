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
		DEFAULT => -62
	},
	{#State 3
		ACTIONS => {
			"=" => 20
		},
		DEFAULT => -30
	},
	{#State 4
		DEFAULT => -64
	},
	{#State 5
		DEFAULT => -63
	},
	{#State 6
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			":->" => 33,
			"!=" => 34,
			"|||" => 35,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
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
			'array' => 42,
			'expr' => 43,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 8
		DEFAULT => -26
	},
	{#State 9
		ACTIONS => {
			"[" => 44,
			"::-" => 48,
			"|" => 50,
			":=" => 45,
			"=!=" => 47,
			"{" => 46,
			"=" => 49,
			":-" => 51
		},
		DEFAULT => -27
	},
	{#State 10
		ACTIONS => {
			'' => 52
		}
	},
	{#State 11
		ACTIONS => {
			'NAME' => 54
		},
		GOTOS => {
			'assignexpr' => 53
		}
	},
	{#State 12
		ACTIONS => {
			"(" => 16,
			'NUMBER' => 8,
			'NAME' => 56
		},
		DEFAULT => -34,
		GOTOS => {
			'exprval' => 57,
			'arrayfetchexpr' => 55
		}
	},
	{#State 13
		ACTIONS => {
			"|" => 58
		}
	},
	{#State 14
		ACTIONS => {
			"(" => 59
		}
	},
	{#State 15
		ACTIONS => {
			";" => 60
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
			'expr' => 61,
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
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -35
	},
	{#State 19
		ACTIONS => {
			"[" => 44,
			"::-" => 48,
			"|" => 50,
			"{" => 46,
			"=" => 49,
			":-" => 51
		},
		DEFAULT => -27
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
			'expr' => 62,
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
			'expr' => 63,
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
			'expr' => 64,
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
			'expr' => 65,
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
			'expr' => 66,
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
			'expr' => 67,
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
			'expr' => 68,
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
			'expr' => 69,
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
			'expr' => 70,
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
			'expr' => 71,
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
			'expr' => 72,
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
			'expr' => 73,
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
			'expr' => 74,
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
			'expr' => 75,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 34
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
	{#State 35
		ACTIONS => {
			'NAME' => 77
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
			'expr' => 78,
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
			'expr' => 79,
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
			'expr' => 80,
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
			'expr' => 81,
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
			'expr' => 82,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 41
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
			'expr' => 83,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 42
		ACTIONS => {
			"]" => 84
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"," => 85,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -14
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
		DEFAULT => -18,
		GOTOS => {
			'expr' => 86,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'argarray' => 87,
			'assignexpr' => 4
		}
	},
	{#State 45
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
			'expr' => 88,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 46
		ACTIONS => {
			'NAME' => 90
		},
		DEFAULT => -23,
		GOTOS => {
			'arglist' => 91,
			'argelement' => 89
		}
	},
	{#State 47
		ACTIONS => {
			'NAME' => 92
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
			'expr' => 93,
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
		GOTOS => {
			'expr' => 94,
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
		DEFAULT => -15,
		GOTOS => {
			'array' => 95,
			'expr' => 43,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 51
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
	{#State 52
		DEFAULT => 0
	},
	{#State 53
		DEFAULT => -6
	},
	{#State 54
		ACTIONS => {
			"=" => 49
		},
		DEFAULT => -5
	},
	{#State 55
		DEFAULT => -30
	},
	{#State 56
		ACTIONS => {
			"[" => 44,
			"|" => 50
		},
		DEFAULT => -27
	},
	{#State 57
		ACTIONS => {
			"(" => 16,
			'NUMBER' => 8,
			'NAME' => 56
		},
		DEFAULT => -31,
		GOTOS => {
			'exprval' => 57,
			'arrayfetchexpr' => 55
		}
	},
	{#State 58
		ACTIONS => {
			'NAME' => 90
		},
		DEFAULT => -23,
		GOTOS => {
			'arglist' => 97,
			'argelement' => 89
		}
	},
	{#State 59
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
			'expr' => 98,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 60
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
			'stma' => 99,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 61
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			")" => 100,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		}
	},
	{#State 62
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -60
	},
	{#State 63
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"/" => 38
		},
		DEFAULT => -38
	},
	{#State 64
		ACTIONS => {
			"-" => 21,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"/" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -45
	},
	{#State 65
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -47
	},
	{#State 66
		DEFAULT => -44
	},
	{#State 67
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"/" => 38
		},
		DEFAULT => -37
	},
	{#State 68
		ACTIONS => {
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -42
	},
	{#State 69
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -51
	},
	{#State 70
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -50
	},
	{#State 71
		DEFAULT => -43
	},
	{#State 72
		ACTIONS => {
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -36
	},
	{#State 73
		ACTIONS => {
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -39
	},
	{#State 74
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"/" => 38
		},
		DEFAULT => -41
	},
	{#State 75
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -8
	},
	{#State 76
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -53
	},
	{#State 77
		DEFAULT => -10
	},
	{#State 78
		ACTIONS => {
			":" => 101,
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -61
	},
	{#State 80
		ACTIONS => {
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -40
	},
	{#State 81
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -52
	},
	{#State 82
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -49
	},
	{#State 83
		ACTIONS => {
			"-" => 21,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -48
	},
	{#State 84
		DEFAULT => -58
	},
	{#State 85
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
			'array' => 102,
			'expr' => 43,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 86
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"," => 103,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -17
	},
	{#State 87
		ACTIONS => {
			"]" => 104
		}
	},
	{#State 88
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -7
	},
	{#State 89
		ACTIONS => {
			"," => 105
		},
		DEFAULT => -25
	},
	{#State 90
		ACTIONS => {
			"isa" => 107,
			"=" => 106
		},
		DEFAULT => -22
	},
	{#State 91
		ACTIONS => {
			"}" => 108
		}
	},
	{#State 92
		DEFAULT => -9
	},
	{#State 93
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -54
	},
	{#State 94
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -32
	},
	{#State 95
		ACTIONS => {
			"|" => 109
		}
	},
	{#State 96
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -55
	},
	{#State 97
		ACTIONS => {
			"|" => 110
		}
	},
	{#State 98
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			")" => 111,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		}
	},
	{#State 99
		DEFAULT => -3
	},
	{#State 100
		DEFAULT => -28
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
			'expr' => 112,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 102
		DEFAULT => -13
	},
	{#State 103
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
		DEFAULT => -18,
		GOTOS => {
			'expr' => 86,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'argarray' => 113,
			'assignexpr' => 4
		}
	},
	{#State 104
		DEFAULT => -29
	},
	{#State 105
		ACTIONS => {
			'NAME' => 90
		},
		DEFAULT => -23,
		GOTOS => {
			'arglist' => 114,
			'argelement' => 89
		}
	},
	{#State 106
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
			'expr' => 115,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 107
		ACTIONS => {
			'NAME' => 116
		}
	},
	{#State 108
		ACTIONS => {
			":=" => 117
		}
	},
	{#State 109
		DEFAULT => -33
	},
	{#State 110
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
			'expr' => 118,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 111
		ACTIONS => {
			"{" => 119
		}
	},
	{#State 112
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -46
	},
	{#State 113
		DEFAULT => -16
	},
	{#State 114
		DEFAULT => -24
	},
	{#State 115
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -21
	},
	{#State 116
		ACTIONS => {
			"=" => 120
		},
		DEFAULT => -20
	},
	{#State 117
		ACTIONS => {
			"-" => 1,
			'NAME' => 19,
			'DATE' => 2,
			"{" => 122,
			'STRING' => 5,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		GOTOS => {
			'expr' => 121,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 118
		ACTIONS => {
			"}" => 123,
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		}
	},
	{#State 119
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
			'stma' => 124,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 120
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
			'expr' => 125,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 121
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -56
	},
	{#State 122
		ACTIONS => {
			"-" => 1,
			'NAME' => 9,
			"var" => 11,
			'DATE' => 2,
			"{" => 13,
			"while" => 14,
			'STRING' => 5,
			"|" => 58,
			"(" => 16,
			"[" => 7,
			'NUMBER' => 8
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 15,
			'while' => 17,
			'stma' => 126,
			'expr' => 6,
			'exprval' => 12,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 123
		DEFAULT => -59
	},
	{#State 124
		ACTIONS => {
			"}" => 127
		}
	},
	{#State 125
		ACTIONS => {
			"-" => 21,
			"conforms" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			" " => 30,
			"^" => 29,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 36,
			"/" => 38,
			"->" => 37,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -19
	},
	{#State 126
		ACTIONS => {
			"}" => 128
		}
	},
	{#State 127
		DEFAULT => -12
	},
	{#State 128
		DEFAULT => -57
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
		 'while', 7,
sub
#line 49 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 13
		 'array', 3,
sub
#line 56 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 14
		 'array', 1,
sub
#line 57 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 15
		 'array', 0, undef
	],
	[#Rule 16
		 'argarray', 3,
sub
#line 61 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 17
		 'argarray', 1,
sub
#line 62 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 18
		 'argarray', 0, undef
	],
	[#Rule 19
		 'argelement', 5,
sub
#line 66 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 20
		 'argelement', 3,
sub
#line 67 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 21
		 'argelement', 3,
sub
#line 68 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 22
		 'argelement', 1,
sub
#line 69 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 23
		 'argelement', 0, undef
	],
	[#Rule 24
		 'arglist', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 25
		 'arglist', 1,
sub
#line 74 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 26
		 'exprval', 1,
sub
#line 77 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 27
		 'exprval', 1,
sub
#line 78 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 28
		 'exprval', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 29
		 'exprval', 4,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 30
		 'exprval', 1, undef
	],
	[#Rule 31
		 'exprval', 2,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 32
		 'assignexpr', 3,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 33
		 'arrayfetchexpr', 4,
sub
#line 89 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'),$_[3] ], 'ArrayFetch' }
	],
	[#Rule 34
		 'expr', 1,
sub
#line 93 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 35
		 'expr', 2,
sub
#line 94 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 95 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 96 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 97 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 98 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 99 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 101 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 102 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 46
		 'expr', 5,
sub
#line 105 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 48
		 'expr', 3,
sub
#line 107 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 49
		 'expr', 3,
sub
#line 108 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 50
		 'expr', 3,
sub
#line 109 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 51
		 'expr', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 112 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 54
		 'expr', 3,
sub
#line 113 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 55
		 'expr', 3,
sub
#line 114 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 56
		 'expr', 6,
sub
#line 115 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 57
		 'expr', 8,
sub
#line 116 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 117 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 59
		 'expr', 6,
sub
#line 118 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 60
		 'expr', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 61
		 'expr', 3,
sub
#line 120 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 62
		 'expr', 1,
sub
#line 121 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 63
		 'expr', 1,
sub
#line 122 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 64
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 125 "Farnsworth.yp"


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
    $s =~ /\G\s*#([^#]*)#\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*("(\\.|[^"\\])*")/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(while|conforms)\b\s*/cg and return $1;

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
