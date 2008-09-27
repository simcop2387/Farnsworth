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
			'NAME' => 2,
			"var" => 6,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 10,
			'expr' => 12,
			'stma' => 3,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			"(" => 11,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			"[" => 13,
			'NUMBER' => 14,
			'STRING' => 9
		},
		GOTOS => {
			'expr' => 16,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 24,
			"::-" => 20,
			"|" => 22,
			":=" => 17,
			"=!=" => 19,
			"{" => 18,
			"=" => 21,
			":-" => 23
		},
		DEFAULT => -20
	},
	{#State 3
		ACTIONS => {
			'' => 25
		}
	},
	{#State 4
		DEFAULT => -53
	},
	{#State 5
		ACTIONS => {
			"(" => 11,
			'NUMBER' => 14,
			'NAME' => 26
		},
		DEFAULT => -26,
		GOTOS => {
			'exprval' => 27
		}
	},
	{#State 6
		ACTIONS => {
			'NAME' => 28
		},
		GOTOS => {
			'assignexpr' => 29
		}
	},
	{#State 7
		ACTIONS => {
			"|" => 30
		}
	},
	{#State 8
		DEFAULT => -55
	},
	{#State 9
		DEFAULT => -54
	},
	{#State 10
		ACTIONS => {
			";" => 31
		},
		DEFAULT => -2
	},
	{#State 11
		ACTIONS => {
			"-" => 1,
			"(" => 11,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			"[" => 13,
			'NUMBER' => 14,
			'STRING' => 9
		},
		GOTOS => {
			'expr' => 32,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 12
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			":->" => 44,
			"!=" => 45,
			"|||" => 46,
			"?" => 47,
			"/" => 49,
			"->" => 48,
			"<=>" => 51,
			"<=" => 50,
			">" => 52
		},
		DEFAULT => -4
	},
	{#State 13
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'array' => 53,
			'expr' => 54,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 14
		DEFAULT => -19
	},
	{#State 15
		ACTIONS => {
			"[" => 24,
			"::-" => 20,
			"|" => 22,
			"{" => 18,
			"=" => 21,
			":-" => 23
		},
		DEFAULT => -20
	},
	{#State 16
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -27
	},
	{#State 17
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 55,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 18
		ACTIONS => {
			'NAME' => 57
		},
		GOTOS => {
			'arglist' => 58,
			'argelement' => 56
		}
	},
	{#State 19
		ACTIONS => {
			'NAME' => 59
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 60,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 21
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 61,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'array' => 62,
			'expr' => 54,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 63,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'array' => 64,
			'expr' => 54,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 25
		DEFAULT => 0
	},
	{#State 26
		ACTIONS => {
			"[" => 24,
			"|" => 65
		},
		DEFAULT => -20
	},
	{#State 27
		ACTIONS => {
			"(" => 11,
			'NUMBER' => 14,
			'NAME' => 26
		},
		DEFAULT => -24,
		GOTOS => {
			'exprval' => 27
		}
	},
	{#State 28
		ACTIONS => {
			"=" => 21
		},
		DEFAULT => -5
	},
	{#State 29
		DEFAULT => -6
	},
	{#State 30
		ACTIONS => {
			'NAME' => 57
		},
		GOTOS => {
			'arglist' => 66,
			'argelement' => 56
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			"var" => 6,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 10,
			'stma' => 67,
			'expr' => 12,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			")" => 68,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 69,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 70,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 71,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 72,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 73,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 74,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 75,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 77,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 78,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 79,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 81,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 46
		ACTIONS => {
			'NAME' => 82
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 83,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 84,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 85,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 86,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 51
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 87,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 52
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 88,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 53
		ACTIONS => {
			"]" => 89
		}
	},
	{#State 54
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"," => 90,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"/" => 49,
			"->" => 48,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -12
	},
	{#State 55
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -7
	},
	{#State 56
		ACTIONS => {
			"," => 91
		},
		DEFAULT => -18
	},
	{#State 57
		ACTIONS => {
			"isa" => 93,
			"=" => 92
		},
		DEFAULT => -16
	},
	{#State 58
		ACTIONS => {
			"}" => 94
		}
	},
	{#State 59
		DEFAULT => -9
	},
	{#State 60
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -45
	},
	{#State 61
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -25
	},
	{#State 62
		ACTIONS => {
			"|" => 95
		}
	},
	{#State 63
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -46
	},
	{#State 64
		ACTIONS => {
			"]" => 96
		}
	},
	{#State 65
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'array' => 97,
			'expr' => 54,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 66
		ACTIONS => {
			"|" => 98
		}
	},
	{#State 67
		DEFAULT => -3
	},
	{#State 68
		DEFAULT => -21
	},
	{#State 69
		ACTIONS => {
			"**" => 35,
			"%" => 37,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"/" => 49
		},
		DEFAULT => -30
	},
	{#State 70
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 71
		DEFAULT => -36
	},
	{#State 72
		ACTIONS => {
			"**" => 35,
			"%" => 37,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"/" => 49
		},
		DEFAULT => -29
	},
	{#State 73
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -34
	},
	{#State 74
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -42
	},
	{#State 75
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -41
	},
	{#State 76
		DEFAULT => -35
	},
	{#State 77
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -28
	},
	{#State 78
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -31
	},
	{#State 79
		ACTIONS => {
			"**" => 35,
			"%" => 37,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"/" => 49
		},
		DEFAULT => -33
	},
	{#State 80
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -8
	},
	{#State 81
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -44
	},
	{#State 82
		DEFAULT => -10
	},
	{#State 83
		ACTIONS => {
			":" => 99,
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		}
	},
	{#State 84
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -52
	},
	{#State 85
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -32
	},
	{#State 86
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 87
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -43
	},
	{#State 88
		ACTIONS => {
			"-" => 33,
			"<" => undef,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => undef,
			"/" => 49,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 89
		DEFAULT => -49
	},
	{#State 90
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'array' => 100,
			'expr' => 54,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 91
		ACTIONS => {
			'NAME' => 57
		},
		GOTOS => {
			'arglist' => 101,
			'argelement' => 56
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 102,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 93
		ACTIONS => {
			'NAME' => 103
		}
	},
	{#State 94
		ACTIONS => {
			":=" => 104
		}
	},
	{#State 95
		ACTIONS => {
			"=" => 105
		},
		DEFAULT => -23
	},
	{#State 96
		DEFAULT => -22
	},
	{#State 97
		ACTIONS => {
			"|" => 106
		}
	},
	{#State 98
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 107,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 99
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 108,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 100
		DEFAULT => -11
	},
	{#State 101
		DEFAULT => -17
	},
	{#State 102
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -15
	},
	{#State 103
		ACTIONS => {
			"=" => 109
		},
		DEFAULT => -14
	},
	{#State 104
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 111,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 110,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 105
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 112,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 106
		DEFAULT => -23
	},
	{#State 107
		ACTIONS => {
			"}" => 113,
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		}
	},
	{#State 108
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -37
	},
	{#State 109
		ACTIONS => {
			"-" => 1,
			'NAME' => 15,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		GOTOS => {
			'expr' => 114,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 110
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -47
	},
	{#State 111
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			"var" => 6,
			'DATE' => 4,
			"{" => 7,
			'STRING' => 9,
			"|" => 30,
			"(" => 11,
			"[" => 13,
			'NUMBER' => 14
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 10,
			'stma' => 115,
			'expr' => 12,
			'exprval' => 5,
			'assignexpr' => 8
		}
	},
	{#State 112
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -51
	},
	{#State 113
		DEFAULT => -50
	},
	{#State 114
		ACTIONS => {
			"-" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			"^" => 40,
			" " => 41,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 47,
			"->" => 48,
			"/" => 49,
			"<=" => 50,
			"<=>" => 51,
			">" => 52
		},
		DEFAULT => -13
	},
	{#State 115
		ACTIONS => {
			"}" => 116
		}
	},
	{#State 116
		DEFAULT => -48
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
		 'array', 3,
sub
#line 53 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 12
		 'array', 1,
sub
#line 54 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 13
		 'argelement', 5,
sub
#line 57 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 14
		 'argelement', 3,
sub
#line 58 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 15
		 'argelement', 3,
sub
#line 59 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 16
		 'argelement', 1,
sub
#line 60 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 17
		 'arglist', 3,
sub
#line 63 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 18
		 'arglist', 1,
sub
#line 64 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 19
		 'exprval', 1,
sub
#line 67 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 20
		 'exprval', 1,
sub
#line 68 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 21
		 'exprval', 3,
sub
#line 69 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 22
		 'exprval', 4,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 23
		 'exprval', 4,
sub
#line 71 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'),$_[3] ], 'ArrayFetch' }
	],
	[#Rule 24
		 'exprval', 2,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 25
		 'assignexpr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 26
		 'expr', 1,
sub
#line 80 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 27
		 'expr', 2,
sub
#line 81 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 87 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 88 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 89 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 90 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 37
		 'expr', 5,
sub
#line 91 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 92 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 93 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 94 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 95 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 96 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 97 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 98 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 99 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 47
		 'expr', 6,
sub
#line 101 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 48
		 'expr', 8,
sub
#line 102 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 49
		 'expr', 3,
sub
#line 103 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 50
		 'expr', 6,
sub
#line 104 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 51
		 'expr', 6,
sub
#line 105 "Farnsworth.yp"
{ bless [ @_[1,2,3]], 'ArrayStore' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 53
		 'expr', 1,
sub
#line 107 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 54
		 'expr', 1,
sub
#line 108 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 55
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 111 "Farnsworth.yp"


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
