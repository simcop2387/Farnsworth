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

#line 11 "Farnsworth.yp"

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
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'expr' => 10,
			'stma' => 3
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			" " => 8,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 14
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 20,
			":=" => 15,
			"=!=" => 16,
			"::-" => 17,
			"=" => 18,
			":-" => 19
		},
		DEFAULT => -21
	},
	{#State 3
		ACTIONS => {
			'' => 21
		}
	},
	{#State 4
		DEFAULT => -22
	},
	{#State 5
		ACTIONS => {
			"|" => 22
		}
	},
	{#State 6
		DEFAULT => -23
	},
	{#State 7
		ACTIONS => {
			";" => 23
		},
		DEFAULT => -2
	},
	{#State 8
		DEFAULT => -51
	},
	{#State 9
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			" " => 8,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 24
		}
	},
	{#State 10
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			":->" => 36,
			"!=" => 37,
			"|||" => 38,
			"?" => 39,
			"/" => 41,
			"->" => 40,
			"(" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -4
	},
	{#State 11
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 46,
			'expr' => 47
		}
	},
	{#State 12
		ACTIONS => {
			'NAME' => 48
		},
		DEFAULT => -20
	},
	{#State 13
		ACTIONS => {
			"[" => 49,
			"::-" => 17,
			"=" => 18,
			":-" => 19
		},
		DEFAULT => -21
	},
	{#State 14
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"/" => 41,
			"(" => 42
		},
		DEFAULT => -24
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 50
		}
	},
	{#State 16
		ACTIONS => {
			'NAME' => 51
		}
	},
	{#State 17
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 52
		}
	},
	{#State 18
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 53
		}
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 54
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 57,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'arglist' => 58,
			'array' => 56,
			'expr' => 47,
			'argelement' => 55
		}
	},
	{#State 21
		DEFAULT => 0
	},
	{#State 22
		ACTIONS => {
			'NAME' => 59
		},
		GOTOS => {
			'arglist' => 60,
			'argelement' => 55
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			"(" => 9,
			" " => 8,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 61,
			'expr' => 10
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			")" => 62,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 63
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 64
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 65
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 66
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 67
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 68
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 69
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 70
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 71
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 72
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 73
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 74
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 75
		}
	},
	{#State 38
		ACTIONS => {
			'NAME' => 76
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 77
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 78
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 79
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 80
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 81
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 82
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 83
		}
	},
	{#State 46
		ACTIONS => {
			"]" => 84
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"," => 85,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -13
	},
	{#State 48
		DEFAULT => -26
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 56,
			'expr' => 47
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -7
	},
	{#State 51
		DEFAULT => -10
	},
	{#State 52
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -43
	},
	{#State 53
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -25
	},
	{#State 54
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -44
	},
	{#State 55
		ACTIONS => {
			"," => 86
		},
		DEFAULT => -19
	},
	{#State 56
		ACTIONS => {
			"]" => 87
		}
	},
	{#State 57
		ACTIONS => {
			"," => -17,
			"[" => 49,
			"]" => -17,
			"::-" => 17,
			"=" => 88,
			"isa" => 89,
			":-" => 19
		},
		DEFAULT => -21
	},
	{#State 58
		ACTIONS => {
			"]" => 90
		}
	},
	{#State 59
		ACTIONS => {
			"isa" => 89,
			"=" => 91
		},
		DEFAULT => -17
	},
	{#State 60
		ACTIONS => {
			"|" => 92
		}
	},
	{#State 61
		DEFAULT => -3
	},
	{#State 62
		DEFAULT => -48
	},
	{#State 63
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"/" => 41,
			"(" => 42
		},
		DEFAULT => -28
	},
	{#State 64
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 65
		ACTIONS => {
			"(" => 42
		},
		DEFAULT => -35
	},
	{#State 66
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"/" => 41,
			"(" => 42
		},
		DEFAULT => -27
	},
	{#State 67
		ACTIONS => {
			"**" => 27,
			"^" => 32,
			"(" => 42
		},
		DEFAULT => -33
	},
	{#State 68
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 69
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 70
		ACTIONS => {
			"(" => 42
		},
		DEFAULT => -34
	},
	{#State 71
		ACTIONS => {
			"**" => 27,
			"^" => 32,
			"(" => 42
		},
		DEFAULT => -29
	},
	{#State 72
		ACTIONS => {
			"**" => 27,
			"^" => 32,
			"(" => 42
		},
		DEFAULT => -30
	},
	{#State 73
		ACTIONS => {
			"**" => 27,
			"%" => 29,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"/" => 41,
			"(" => 42
		},
		DEFAULT => -32
	},
	{#State 74
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -9
	},
	{#State 75
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -42
	},
	{#State 76
		DEFAULT => -11
	},
	{#State 77
		ACTIONS => {
			":" => 93,
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		}
	},
	{#State 78
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -8
	},
	{#State 79
		ACTIONS => {
			"**" => 27,
			"^" => 32,
			"(" => 42
		},
		DEFAULT => -31
	},
	{#State 80
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			")" => 94,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		}
	},
	{#State 81
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 82
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -41
	},
	{#State 83
		ACTIONS => {
			"-" => 25,
			"<" => undef,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => undef,
			">=" => undef,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => undef,
			"/" => 41,
			"(" => 42,
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
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 95,
			'expr' => 47
		}
	},
	{#State 86
		ACTIONS => {
			'NAME' => 59
		},
		GOTOS => {
			'arglist' => 96,
			'argelement' => 55
		}
	},
	{#State 87
		DEFAULT => -46
	},
	{#State 88
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 97
		}
	},
	{#State 89
		ACTIONS => {
			'NAME' => 98
		}
	},
	{#State 90
		ACTIONS => {
			":=" => 99
		}
	},
	{#State 91
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 100
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 101
		}
	},
	{#State 93
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 102
		}
	},
	{#State 94
		DEFAULT => -49
	},
	{#State 95
		DEFAULT => -12
	},
	{#State 96
		DEFAULT => -18
	},
	{#State 97
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -16
	},
	{#State 98
		ACTIONS => {
			"=" => 103
		},
		DEFAULT => -15
	},
	{#State 99
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 105,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 104
		}
	},
	{#State 100
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -16
	},
	{#State 101
		ACTIONS => {
			"}" => 106,
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		}
	},
	{#State 102
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -45
	},
	{#State 103
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 107
		}
	},
	{#State 104
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -5
	},
	{#State 105
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			"|" => 22,
			"(" => 9,
			" " => 8,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 108,
			'expr' => 10
		}
	},
	{#State 106
		DEFAULT => -50
	},
	{#State 107
		ACTIONS => {
			"-" => 25,
			"<" => 26,
			"+" => 28,
			"**" => 27,
			"%" => 29,
			"==" => 30,
			">=" => 31,
			"^" => 32,
			" " => 33,
			"*" => 34,
			"per" => 35,
			"!=" => 37,
			"?" => 39,
			"/" => 41,
			"(" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -14
	},
	{#State 108
		ACTIONS => {
			"}" => 109
		}
	},
	{#State 109
		DEFAULT => -6
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
#line 22 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 23 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 24 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 28 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 6,
sub
#line 29 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 6
		 'stmt', 8,
sub
#line 30 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 31 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 34 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 11
		 'stmt', 3,
sub
#line 35 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 12
		 'array', 3,
sub
#line 48 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 13
		 'array', 1,
sub
#line 49 "Farnsworth.yp"
{ bless [ $_[1]], 'Array'}
	],
	[#Rule 14
		 'argelement', 5,
sub
#line 52 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 15
		 'argelement', 3,
sub
#line 53 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 16
		 'argelement', 3,
sub
#line 54 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 17
		 'argelement', 1,
sub
#line 55 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 18
		 'arglist', 3,
sub
#line 58 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 19
		 'arglist', 1,
sub
#line 59 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 20
		 'expr', 1,
sub
#line 63 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 21
		 'expr', 1,
sub
#line 64 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 22
		 'expr', 1,
sub
#line 65 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 23
		 'expr', 1,
sub
#line 66 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 24
		 'expr', 2,
sub
#line 67 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 26
		 'expr', 2,
sub
#line 69 "Farnsworth.yp"
{ bless [ $_[1], (bless [ $_[2] ], 'Fetch' )], 'Mul' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3], ' '], 'Mul' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 87 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 45
		 'expr', 5,
sub
#line 88 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 46
		 'expr', 4,
sub
#line 89 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 90 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 48
		 'expr', 3,
sub
#line 91 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 49
		 'expr', 4,
sub
#line 92 "Farnsworth.yp"
{ bless [$_[1],(bless [$_[3]], 'Paren')], 'Mul' }
	],
	[#Rule 50
		 'expr', 6,
sub
#line 93 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 51
		 'expr', 1,
sub
#line 94 "Farnsworth.yp"
{undef}
	]
],
                                  @_);
    bless($self,$class);
}

#line 96 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	$s =~ s/\G\s{2,}/ /c; #don't need global?
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ s|\G//.*||g;
	$s =~ s|\G/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;
    $s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1;

    #token out the date
    $s =~ /\G\s*(#[^#]*#)\s*/gc and return 'DATE', $1;

    if ($s =~ /^\s*"/) #"
	{
	   my ($e, $r) =  extract_delimited($s, '"');
	   $s = $r;
	   return 'STRING', $e
	}

#	$s =~ /\s*("([^\\"]*(?:\\.[^\\"]*)*)")\s*/gc and return 'STRING', $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /\G\s*(:=|==|!=|<=>|>=|<=|->|:->|\*\*)\s*/icg and return lc $1;
	$s =~ /\G\s*(\bper\b|\bisa\b|\:?\:\-|\=\!\=|\|\|\|)\s*/icg and return lc $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^|=|;|\{|\}|\>|\<|\?|\:|\,)\s*/cg and return $1;
	$s =~ /\G\s*(\))/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\()\s*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yylexwatch
{
   my @r = &yylex;
#   print Dumper(\@r,[pos $s]);
   $charcount+=pos $s;
   $s = substr($s, pos $s);
   return @r;
}

sub yyerror
	{
	my $pos = $charcount;
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
