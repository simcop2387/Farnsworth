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
		DEFAULT => -66
	},
	{#State 3
		ACTIONS => {
			"=" => 22
		},
		DEFAULT => -33
	},
	{#State 4
		DEFAULT => -68
	},
	{#State 5
		DEFAULT => -67
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
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -18,
		GOTOS => {
			'array' => 46,
			'expr' => 47,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 10
		DEFAULT => -29
	},
	{#State 11
		ACTIONS => {
			"[" => 48,
			"::-" => 52,
			"|" => 54,
			":=" => 49,
			"=!=" => 51,
			"{" => 50,
			"=" => 53,
			":-" => 55
		},
		DEFAULT => -30
	},
	{#State 12
		ACTIONS => {
			'' => 56
		}
	},
	{#State 13
		ACTIONS => {
			'NAME' => 58
		},
		GOTOS => {
			'assignexpr' => 57
		}
	},
	{#State 14
		ACTIONS => {
			"(" => 19,
			'NUMBER' => 10,
			'NAME' => 60
		},
		DEFAULT => -37,
		GOTOS => {
			'exprval' => 61,
			'arrayfetchexpr' => 59
		}
	},
	{#State 15
		ACTIONS => {
			"|" => 62
		}
	},
	{#State 16
		ACTIONS => {
			"(" => 63
		}
	},
	{#State 17
		ACTIONS => {
			";" => 64
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
			'expr' => 65,
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
			"[" => 48,
			"::-" => 52,
			"|" => 54,
			"{" => 50,
			"=" => 53,
			":-" => 55
		},
		DEFAULT => -30
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
			'expr' => 66,
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
			'expr' => 67,
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
			'expr' => 68,
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
			'expr' => 69,
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
			'expr' => 70,
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
			'expr' => 71,
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
			'expr' => 72,
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
			'expr' => 73,
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
			'expr' => 74,
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
			'expr' => 75,
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
			'expr' => 76,
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
			'expr' => 77,
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
			'expr' => 78,
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
			'expr' => 79,
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
			'expr' => 80,
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
			'expr' => 81,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 38
		ACTIONS => {
			'NAME' => 82
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
			'expr' => 83,
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
			'expr' => 84,
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
			'expr' => 85,
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
			'expr' => 86,
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
			'expr' => 87,
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
			'expr' => 88,
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
			'expr' => 89,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 46
		ACTIONS => {
			"]" => 90
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"," => 91,
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
	{#State 48
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
		DEFAULT => -21,
		GOTOS => {
			'expr' => 92,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'argarray' => 93,
			'assignexpr' => 4
		}
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
		GOTOS => {
			'expr' => 94,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 50
		ACTIONS => {
			'NAME' => 96
		},
		DEFAULT => -26,
		GOTOS => {
			'arglist' => 97,
			'argelement' => 95
		}
	},
	{#State 51
		ACTIONS => {
			'NAME' => 98
		}
	},
	{#State 52
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
			'expr' => 99,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
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
			'expr' => 100,
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
		DEFAULT => -18,
		GOTOS => {
			'array' => 101,
			'expr' => 47,
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
	{#State 56
		DEFAULT => 0
	},
	{#State 57
		DEFAULT => -6
	},
	{#State 58
		ACTIONS => {
			"=" => 53
		},
		DEFAULT => -5
	},
	{#State 59
		DEFAULT => -33
	},
	{#State 60
		ACTIONS => {
			"[" => 48,
			"|" => 54
		},
		DEFAULT => -30
	},
	{#State 61
		ACTIONS => {
			"(" => 19,
			'NUMBER' => 10,
			'NAME' => 60
		},
		DEFAULT => -34,
		GOTOS => {
			'exprval' => 61,
			'arrayfetchexpr' => 59
		}
	},
	{#State 62
		ACTIONS => {
			'NAME' => 96
		},
		DEFAULT => -26,
		GOTOS => {
			'arglist' => 103,
			'argelement' => 95
		}
	},
	{#State 63
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
	{#State 64
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
			'stma' => 105,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 65
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
			")" => 106,
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
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"=>" => 42,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -64
	},
	{#State 67
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
			")" => 107,
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
	{#State 68
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"/" => 41
		},
		DEFAULT => -41
	},
	{#State 69
		ACTIONS => {
			"-" => 24,
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
			"/" => 41,
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -48
	},
	{#State 70
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -50
	},
	{#State 71
		DEFAULT => -47
	},
	{#State 72
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"/" => 41
		},
		DEFAULT => -40
	},
	{#State 73
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -45
	},
	{#State 74
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -54
	},
	{#State 75
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -53
	},
	{#State 76
		DEFAULT => -46
	},
	{#State 77
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -39
	},
	{#State 78
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -42
	},
	{#State 79
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"/" => 41
		},
		DEFAULT => -44
	},
	{#State 80
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
	{#State 81
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -56
	},
	{#State 82
		DEFAULT => -10
	},
	{#State 83
		ACTIONS => {
			":" => 108,
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
	{#State 84
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
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -65
	},
	{#State 85
		ACTIONS => {
			"**" => 27,
			"^" => 32
		},
		DEFAULT => -43
	},
	{#State 86
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
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -63
	},
	{#State 87
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -55
	},
	{#State 88
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -52
	},
	{#State 89
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			" " => 33,
			"^" => 32,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -51
	},
	{#State 90
		DEFAULT => -61
	},
	{#State 91
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
		DEFAULT => -18,
		GOTOS => {
			'array' => 109,
			'expr' => 47,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 24,
			"conforms" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"," => 110,
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
		DEFAULT => -20
	},
	{#State 93
		ACTIONS => {
			"]" => 111
		}
	},
	{#State 94
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
	{#State 95
		ACTIONS => {
			"," => 112
		},
		DEFAULT => -28
	},
	{#State 96
		ACTIONS => {
			"isa" => 114,
			"=" => 113
		},
		DEFAULT => -25
	},
	{#State 97
		ACTIONS => {
			"}" => 115
		}
	},
	{#State 98
		DEFAULT => -9
	},
	{#State 99
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
		DEFAULT => -57
	},
	{#State 100
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
		DEFAULT => -35
	},
	{#State 101
		ACTIONS => {
			"|" => 116
		}
	},
	{#State 102
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
		DEFAULT => -58
	},
	{#State 103
		ACTIONS => {
			"|" => 117
		}
	},
	{#State 104
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
			")" => 118,
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
	{#State 105
		DEFAULT => -3
	},
	{#State 106
		DEFAULT => -31
	},
	{#State 107
		ACTIONS => {
			"{" => 119
		}
	},
	{#State 108
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
			'expr' => 120,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 109
		DEFAULT => -16
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
		DEFAULT => -21,
		GOTOS => {
			'expr' => 92,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'argarray' => 121,
			'assignexpr' => 4
		}
	},
	{#State 111
		DEFAULT => -32
	},
	{#State 112
		ACTIONS => {
			'NAME' => 96
		},
		DEFAULT => -26,
		GOTOS => {
			'arglist' => 122,
			'argelement' => 95
		}
	},
	{#State 113
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
			'expr' => 123,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 114
		ACTIONS => {
			'NAME' => 124
		}
	},
	{#State 115
		ACTIONS => {
			":=" => 125
		}
	},
	{#State 116
		DEFAULT => -36
	},
	{#State 117
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
			'stma' => 126,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 118
		ACTIONS => {
			"{" => 127
		}
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
			"<=" => 44,
			"<=>" => 43,
			">" => 45
		},
		DEFAULT => -49
	},
	{#State 121
		DEFAULT => -19
	},
	{#State 122
		DEFAULT => -27
	},
	{#State 123
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
	{#State 124
		ACTIONS => {
			"=" => 129
		},
		DEFAULT => -23
	},
	{#State 125
		ACTIONS => {
			"-" => 1,
			'NAME' => 21,
			'DATE' => 2,
			"{" => 131,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 130,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 126
		ACTIONS => {
			"}" => 132
		}
	},
	{#State 127
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
			'stma' => 133,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
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
			'NAME' => 21,
			'DATE' => 2,
			"{" => 15,
			'STRING' => 5,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		GOTOS => {
			'expr' => 135,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'assignexpr' => 4
		}
	},
	{#State 130
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
		DEFAULT => -59
	},
	{#State 131
		ACTIONS => {
			"-" => 1,
			'NAME' => 11,
			"var" => 13,
			'DATE' => 2,
			"{" => 15,
			"while" => 16,
			'STRING' => 5,
			"if" => 7,
			"|" => 62,
			"(" => 19,
			"[" => 9,
			'NUMBER' => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 17,
			'while' => 18,
			'stma' => 136,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 132
		DEFAULT => -62
	},
	{#State 133
		ACTIONS => {
			"}" => 137
		}
	},
	{#State 134
		ACTIONS => {
			"else" => 138
		},
		DEFAULT => -13
	},
	{#State 135
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
		DEFAULT => -22
	},
	{#State 136
		ACTIONS => {
			"}" => 139
		}
	},
	{#State 137
		DEFAULT => -15
	},
	{#State 138
		ACTIONS => {
			"{" => 140
		}
	},
	{#State 139
		DEFAULT => -60
	},
	{#State 140
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
			'stma' => 141,
			'expr' => 8,
			'exprval' => 14,
			'arrayfetchexpr' => 3,
			'if' => 6,
			'assignexpr' => 4
		}
	},
	{#State 141
		ACTIONS => {
			"}" => 142
		}
	},
	{#State 142
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
		 'array', 0, undef
	],
	[#Rule 19
		 'argarray', 3,
sub
#line 66 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 20
		 'argarray', 1,
sub
#line 67 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 21
		 'argarray', 0, undef
	],
	[#Rule 22
		 'argelement', 5,
sub
#line 71 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 23
		 'argelement', 3,
sub
#line 72 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 24
		 'argelement', 3,
sub
#line 73 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 25
		 'argelement', 1,
sub
#line 74 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 26
		 'argelement', 0, undef
	],
	[#Rule 27
		 'arglist', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 28
		 'arglist', 1,
sub
#line 79 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 29
		 'exprval', 1,
sub
#line 82 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 30
		 'exprval', 1,
sub
#line 83 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 31
		 'exprval', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 32
		 'exprval', 4,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 33
		 'exprval', 1, undef
	],
	[#Rule 34
		 'exprval', 2,
sub
#line 88 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
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
		 'expr', 3,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 107 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
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
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 49
		 'expr', 5,
sub
#line 110 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 50
		 'expr', 3,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 51
		 'expr', 3,
sub
#line 112 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 113 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 114 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 54
		 'expr', 3,
sub
#line 115 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 55
		 'expr', 3,
sub
#line 116 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 57
		 'expr', 3,
sub
#line 118 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 59
		 'expr', 6,
sub
#line 120 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 60
		 'expr', 8,
sub
#line 121 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 61
		 'expr', 3,
sub
#line 122 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 62
		 'expr', 6,
sub
#line 123 "Farnsworth.yp"
{bless [ @_[3,5] ], 'Lambda'}
	],
	[#Rule 63
		 'expr', 3,
sub
#line 124 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 64
		 'expr', 3,
sub
#line 125 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 65
		 'expr', 3,
sub
#line 126 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 66
		 'expr', 1,
sub
#line 127 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 67
		 'expr', 1,
sub
#line 128 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 68
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 131 "Farnsworth.yp"


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
