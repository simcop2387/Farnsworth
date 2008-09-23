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

#line 10 "Farnsworth.yp"

use Data::Dumper; #boobs
my $s;		# warning - not re-entrant
my $lasttype;


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
			'NAME' => 13
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 16,
			":=" => 14,
			"=" => 15
		},
		DEFAULT => -17
	},
	{#State 3
		ACTIONS => {
			'' => 17
		}
	},
	{#State 4
		DEFAULT => -18
	},
	{#State 5
		ACTIONS => {
			"|" => 18
		}
	},
	{#State 6
		DEFAULT => -19
	},
	{#State 7
		ACTIONS => {
			";" => 19
		},
		DEFAULT => -2
	},
	{#State 8
		DEFAULT => -46
	},
	{#State 9
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			" " => 8,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 21
		}
	},
	{#State 10
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			":->" => 33,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -4
	},
	{#State 11
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 42,
			'expr' => 43
		}
	},
	{#State 12
		ACTIONS => {
			'NAME' => 44
		},
		DEFAULT => -16
	},
	{#State 13
		DEFAULT => -20
	},
	{#State 14
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 45
		}
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 46
		}
	},
	{#State 16
		ACTIONS => {
			"-" => 1,
			'NAME' => 49,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'arglist' => 50,
			'array' => 48,
			'expr' => 43,
			'argelement' => 47
		}
	},
	{#State 17
		DEFAULT => 0
	},
	{#State 18
		ACTIONS => {
			'NAME' => 51
		},
		GOTOS => {
			'arglist' => 52,
			'argelement' => 47
		}
	},
	{#State 19
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
			'stma' => 53,
			'expr' => 10
		}
	},
	{#State 20
		ACTIONS => {
			"[" => 54,
			"=" => 15
		},
		DEFAULT => -17
	},
	{#State 21
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			")" => 55,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 56
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 57
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 58
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 59
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 60
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 61
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 62
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
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
	{#State 42
		ACTIONS => {
			"]" => 76
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"," => 77,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"->" => 36,
			"/" => 37,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -9
	},
	{#State 44
		DEFAULT => -22
	},
	{#State 45
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -6
	},
	{#State 46
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -21
	},
	{#State 47
		ACTIONS => {
			"," => 78
		},
		DEFAULT => -15
	},
	{#State 48
		ACTIONS => {
			"]" => 79
		}
	},
	{#State 49
		ACTIONS => {
			"," => -13,
			"[" => 54,
			"]" => -13,
			"=" => 80,
			"isa" => 81
		},
		DEFAULT => -17
	},
	{#State 50
		ACTIONS => {
			"]" => 82
		}
	},
	{#State 51
		ACTIONS => {
			"isa" => 81,
			"=" => 83
		},
		DEFAULT => -13
	},
	{#State 52
		ACTIONS => {
			"|" => 84
		}
	},
	{#State 53
		DEFAULT => -3
	},
	{#State 54
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 48,
			'expr' => 43
		}
	},
	{#State 55
		DEFAULT => -44
	},
	{#State 56
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -25
	},
	{#State 57
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -35
	},
	{#State 58
		DEFAULT => -32
	},
	{#State 59
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -24
	},
	{#State 60
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -30
	},
	{#State 61
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 62
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 63
		DEFAULT => -31
	},
	{#State 64
		ACTIONS => {
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -26
	},
	{#State 65
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -27
	},
	{#State 66
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -29
	},
	{#State 67
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -7
	},
	{#State 68
		ACTIONS => {
			"-" => 22,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -33
	},
	{#State 69
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -41
	},
	{#State 70
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -23
	},
	{#State 71
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -28
	},
	{#State 72
		ACTIONS => {
			"-" => 22,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -34
	},
	{#State 73
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 74
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 75
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => undef,
			"/" => 37,
			"<<" => 38,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 76
		DEFAULT => -43
	},
	{#State 77
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 85,
			'expr' => 43
		}
	},
	{#State 78
		ACTIONS => {
			'NAME' => 51
		},
		GOTOS => {
			'arglist' => 86,
			'argelement' => 47
		}
	},
	{#State 79
		DEFAULT => -42
	},
	{#State 80
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 87
		}
	},
	{#State 81
		ACTIONS => {
			'NAME' => 88
		}
	},
	{#State 82
		ACTIONS => {
			":=" => 89
		}
	},
	{#State 83
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 90
		}
	},
	{#State 84
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 91
		}
	},
	{#State 85
		DEFAULT => -8
	},
	{#State 86
		DEFAULT => -14
	},
	{#State 87
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -12
	},
	{#State 88
		ACTIONS => {
			"=" => 92
		},
		DEFAULT => -11
	},
	{#State 89
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 93
		}
	},
	{#State 90
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -12
	},
	{#State 91
		ACTIONS => {
			"}" => 94,
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 1,
			'NAME' => 20,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 95
		}
	},
	{#State 93
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -5
	},
	{#State 94
		DEFAULT => -45
	},
	{#State 95
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			">>" => 34,
			"!=" => 35,
			"/" => 37,
			"->" => 36,
			"<<" => 38,
			"<=" => 40,
			"<=>" => 39,
			">" => 41
		},
		DEFAULT => -10
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
#line 19 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 20 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 21 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 25 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 6,
sub
#line 26 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 6
		 'stmt', 3,
sub
#line 27 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 28 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 8
		 'array', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 9
		 'array', 1, undef
	],
	[#Rule 10
		 'argelement', 5,
sub
#line 45 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 11
		 'argelement', 3,
sub
#line 46 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 12
		 'argelement', 3,
sub
#line 47 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 13
		 'argelement', 1,
sub
#line 48 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 14
		 'arglist', 3,
sub
#line 51 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 15
		 'arglist', 1, undef
	],
	[#Rule 16
		 'expr', 1,
sub
#line 56 "Farnsworth.yp"
{ bless [ $_[1] ],   'Num' }
	],
	[#Rule 17
		 'expr', 1,
sub
#line 57 "Farnsworth.yp"
{ bless [ $_[1] ],   'Fetch' }
	],
	[#Rule 18
		 'expr', 1,
sub
#line 58 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 19
		 'expr', 1,
sub
#line 59 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 20
		 'expr', 2,
sub
#line 60 "Farnsworth.yp"
{ bless [ (bless [ $_[2] ], 'Fetch') , '-1', '-name'], 'Mul' }
	],
	[#Rule 21
		 'expr', 3,
sub
#line 61 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 22
		 'expr', 2,
sub
#line 62 "Farnsworth.yp"
{ bless [ $_[1], (bless [ $_[2] ], 'Fetch' )], 'Mul' }
	],
	[#Rule 23
		 'expr', 3,
sub
#line 63 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 64 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 65 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 66 "Farnsworth.yp"
{ bless [ @_[1,3], ' '], 'Mul' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 69 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Bitreduce' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Bitexpand' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 42
		 'expr', 4,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 45
		 'expr', 6,
sub
#line 85 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 46
		 'expr', 1,
sub
#line 86 "Farnsworth.yp"
{undef}
	]
],
                                  @_);
    bless($self,$class);
}

#line 88 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	$s =~ s/\G\s{2,}/ /c; #don't need global?
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

    #i want a complete number regex
	$s =~ /\G([+-]?(\d+(\.\d*)?|\.\d+)([Ee][-+]?\d+)?)/gc 
	      and return 'NUMBER', $1;
    $s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1;

    #token out the date
    $s =~ /\G\s*(#[^#]*#)\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*("(\\"|[^"])*")\s*/gc and return 'STRING', $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(:=|==|!=|>=|<=|->|:->|\*\*|per|isa)\s*/icg and return lc $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^)\s*/cg and return $1;
	$s =~ /\G\s*(\))/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\()\s*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G\/\/.*/cg and return ''; #return nothing for C style comments
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yyerror
	{
	my $pos = pos $s;
	substr($s,$pos,0) = '<###YYLEX###>';
	$s =~ s/^/### /mg;
	die "### Syntax Error \@ $pos of\n$s\n";
	}

sub parse
	{
	$lasttype=0;
	my $self = shift;
	$s = join ' ', @_;
	my $code = eval
		{ $self->new(yylex => \&yylex, yyerror => \&yyerror)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
