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

#line 14 "Farnsworth.yp"

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
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 8,
			'expr' => 10,
			'stma' => 3,
			'exprval' => 5
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 7
		},
		GOTOS => {
			'expr' => 14,
			'exprval' => 5
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 22,
			"::-" => 18,
			"|" => 20,
			":=" => 15,
			"=!=" => 17,
			"{" => 16,
			"=" => 19,
			":-" => 21
		},
		DEFAULT => -19
	},
	{#State 3
		ACTIONS => {
			'' => 23
		}
	},
	{#State 4
		DEFAULT => -50
	},
	{#State 5
		ACTIONS => {
			"(" => 9,
			'NUMBER' => 12,
			'NAME' => 24
		},
		DEFAULT => -24,
		GOTOS => {
			'exprval' => 25
		}
	},
	{#State 6
		ACTIONS => {
			"|" => 26
		}
	},
	{#State 7
		DEFAULT => -51
	},
	{#State 8
		ACTIONS => {
			";" => 27
		},
		DEFAULT => -2
	},
	{#State 9
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 7
		},
		GOTOS => {
			'expr' => 28,
			'exprval' => 5
		}
	},
	{#State 10
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			":->" => 40,
			"!=" => 41,
			"|||" => 42,
			"?" => 43,
			"/" => 45,
			"->" => 44,
			"<=>" => 47,
			"<=" => 46,
			">" => 48
		},
		DEFAULT => -4
	},
	{#State 11
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 49,
			'expr' => 50,
			'exprval' => 5
		}
	},
	{#State 12
		DEFAULT => -18
	},
	{#State 13
		ACTIONS => {
			"[" => 22,
			"::-" => 18,
			"|" => 20,
			"{" => 16,
			":-" => 21
		},
		DEFAULT => -19
	},
	{#State 14
		ACTIONS => {
			"**" => 31,
			"^" => 36
		},
		DEFAULT => -25
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 51,
			'exprval' => 5
		}
	},
	{#State 16
		ACTIONS => {
			'NAME' => 53
		},
		GOTOS => {
			'arglist' => 54,
			'argelement' => 52
		}
	},
	{#State 17
		ACTIONS => {
			'NAME' => 55
		}
	},
	{#State 18
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 56,
			'exprval' => 5
		}
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 57,
			'exprval' => 5
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 58,
			'expr' => 50,
			'exprval' => 5
		}
	},
	{#State 21
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 59,
			'exprval' => 5
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 60,
			'expr' => 50,
			'exprval' => 5
		}
	},
	{#State 23
		DEFAULT => 0
	},
	{#State 24
		ACTIONS => {
			"[" => 22,
			"|" => 20
		},
		DEFAULT => -19
	},
	{#State 25
		ACTIONS => {
			"(" => 9,
			'NUMBER' => 12,
			'NAME' => 24
		},
		DEFAULT => -23,
		GOTOS => {
			'exprval' => 25
		}
	},
	{#State 26
		ACTIONS => {
			'NAME' => 53
		},
		GOTOS => {
			'arglist' => 61,
			'argelement' => 52
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 8,
			'stma' => 62,
			'expr' => 10,
			'exprval' => 5
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			")" => 63,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 64,
			'exprval' => 5
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 65,
			'exprval' => 5
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 66,
			'exprval' => 5
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 67,
			'exprval' => 5
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 68,
			'exprval' => 5
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 69,
			'exprval' => 5
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 70,
			'exprval' => 5
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 71,
			'exprval' => 5
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 72,
			'exprval' => 5
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 73,
			'exprval' => 5
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 74,
			'exprval' => 5
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 75,
			'exprval' => 5
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 5
		}
	},
	{#State 42
		ACTIONS => {
			'NAME' => 77
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 78,
			'exprval' => 5
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 79,
			'exprval' => 5
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 80,
			'exprval' => 5
		}
	},
	{#State 46
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 81,
			'exprval' => 5
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 82,
			'exprval' => 5
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 83,
			'exprval' => 5
		}
	},
	{#State 49
		ACTIONS => {
			"]" => 84
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"," => 85,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"/" => 45,
			"->" => 44,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -11
	},
	{#State 51
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -5
	},
	{#State 52
		ACTIONS => {
			"," => 86
		},
		DEFAULT => -17
	},
	{#State 53
		ACTIONS => {
			"isa" => 88,
			"=" => 87
		},
		DEFAULT => -15
	},
	{#State 54
		ACTIONS => {
			"}" => 89
		}
	},
	{#State 55
		DEFAULT => -8
	},
	{#State 56
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -43
	},
	{#State 57
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -6
	},
	{#State 58
		ACTIONS => {
			"|" => 90
		}
	},
	{#State 59
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -44
	},
	{#State 60
		ACTIONS => {
			"]" => 91
		}
	},
	{#State 61
		ACTIONS => {
			"|" => 92
		}
	},
	{#State 62
		DEFAULT => -3
	},
	{#State 63
		DEFAULT => -20
	},
	{#State 64
		ACTIONS => {
			"**" => 31,
			"%" => 33,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"/" => 45
		},
		DEFAULT => -28
	},
	{#State 65
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 66
		DEFAULT => -34
	},
	{#State 67
		ACTIONS => {
			"**" => 31,
			"%" => 33,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"/" => 45
		},
		DEFAULT => -27
	},
	{#State 68
		ACTIONS => {
			"**" => 31,
			"^" => 36
		},
		DEFAULT => -32
	},
	{#State 69
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 70
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 71
		DEFAULT => -33
	},
	{#State 72
		ACTIONS => {
			"**" => 31,
			"^" => 36
		},
		DEFAULT => -26
	},
	{#State 73
		ACTIONS => {
			"**" => 31,
			"^" => 36
		},
		DEFAULT => -29
	},
	{#State 74
		ACTIONS => {
			"**" => 31,
			"%" => 33,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"/" => 45
		},
		DEFAULT => -31
	},
	{#State 75
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -7
	},
	{#State 76
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -42
	},
	{#State 77
		DEFAULT => -9
	},
	{#State 78
		ACTIONS => {
			":" => 93,
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -49
	},
	{#State 80
		ACTIONS => {
			"**" => 31,
			"^" => 36
		},
		DEFAULT => -30
	},
	{#State 81
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 82
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -41
	},
	{#State 83
		ACTIONS => {
			"-" => 29,
			"<" => undef,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => undef,
			">=" => undef,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => undef,
			"/" => 45,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 84
		DEFAULT => -47
	},
	{#State 85
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 94,
			'expr' => 50,
			'exprval' => 5
		}
	},
	{#State 86
		ACTIONS => {
			'NAME' => 53
		},
		GOTOS => {
			'arglist' => 95,
			'argelement' => 52
		}
	},
	{#State 87
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 96,
			'exprval' => 5
		}
	},
	{#State 88
		ACTIONS => {
			'NAME' => 97
		}
	},
	{#State 89
		ACTIONS => {
			":=" => 98
		}
	},
	{#State 90
		DEFAULT => -22
	},
	{#State 91
		DEFAULT => -21
	},
	{#State 92
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 99,
			'exprval' => 5
		}
	},
	{#State 93
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 100,
			'exprval' => 5
		}
	},
	{#State 94
		DEFAULT => -10
	},
	{#State 95
		DEFAULT => -16
	},
	{#State 96
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -14
	},
	{#State 97
		ACTIONS => {
			"=" => 101
		},
		DEFAULT => -13
	},
	{#State 98
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 103,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 102,
			'exprval' => 5
		}
	},
	{#State 99
		ACTIONS => {
			"}" => 104,
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		}
	},
	{#State 100
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -35
	},
	{#State 101
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 105,
			'exprval' => 5
		}
	},
	{#State 102
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -45
	},
	{#State 103
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 6,
			'STRING' => 7,
			"|" => 26,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 8,
			'stma' => 106,
			'expr' => 10,
			'exprval' => 5
		}
	},
	{#State 104
		DEFAULT => -48
	},
	{#State 105
		ACTIONS => {
			"-" => 29,
			"<" => 30,
			"+" => 32,
			"**" => 31,
			"%" => 33,
			"==" => 34,
			">=" => 35,
			"^" => 36,
			" " => 37,
			"*" => 38,
			"per" => 39,
			"!=" => 41,
			"?" => 43,
			"->" => 44,
			"/" => 45,
			"<=" => 46,
			"<=>" => 47,
			">" => 48
		},
		DEFAULT => -12
	},
	{#State 106
		ACTIONS => {
			"}" => 107
		}
	},
	{#State 107
		DEFAULT => -46
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
#line 25 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 26 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 27 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 31 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 6
		 'stmt', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 34 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 35 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 36 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 10
		 'array', 3,
sub
#line 47 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 11
		 'array', 1,
sub
#line 48 "Farnsworth.yp"
{ bless [ $_[1]], 'Array'}
	],
	[#Rule 12
		 'argelement', 5,
sub
#line 51 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 13
		 'argelement', 3,
sub
#line 52 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 14
		 'argelement', 3,
sub
#line 53 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 15
		 'argelement', 1,
sub
#line 54 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 16
		 'arglist', 3,
sub
#line 57 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 17
		 'arglist', 1,
sub
#line 58 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 18
		 'exprval', 1,
sub
#line 61 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 19
		 'exprval', 1,
sub
#line 62 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 20
		 'exprval', 3,
sub
#line 63 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 21
		 'exprval', 4,
sub
#line 64 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 22
		 'exprval', 4,
sub
#line 65 "Farnsworth.yp"
{ bless [ @_[1,2] ], 'ArrayFetch' }
	],
	[#Rule 23
		 'exprval', 2,
sub
#line 66 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 24
		 'expr', 1,
sub
#line 71 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 25
		 'expr', 2,
sub
#line 72 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 35
		 'expr', 5,
sub
#line 82 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 87 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 88 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 89 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 90 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 91 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 45
		 'expr', 6,
sub
#line 92 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 46
		 'expr', 8,
sub
#line 93 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 94 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 48
		 'expr', 6,
sub
#line 95 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 49
		 'expr', 3,
sub
#line 96 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 50
		 'expr', 1,
sub
#line 97 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 51
		 'expr', 1,
sub
#line 98 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 100 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

#	$s =~ m|\G\s*/\*.*?\*/|gcs and redo; #skip C comments
#	$s =~ s|\G//.*||g;
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
	$s =~ /\G\s*(\bper\b|\bisa\b|\:?\:\-|\=\!\=|\|\|\|)\s*/icg and return lc $1;
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
