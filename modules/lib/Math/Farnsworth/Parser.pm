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
			"(" => 8,
			" " => 7,
			'NAME' => 2,
			'DATE' => 3,
			"{" => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 5
		},
		GOTOS => {
			'stmt' => 6,
			'expr' => 9
		}
	},
	{#State 1
		ACTIONS => {
			'NAME' => 12
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 15,
			":=" => 13,
			"=" => 14
		},
		DEFAULT => -16
	},
	{#State 3
		DEFAULT => -17
	},
	{#State 4
		ACTIONS => {
			"|" => 16
		}
	},
	{#State 5
		DEFAULT => -18
	},
	{#State 6
		ACTIONS => {
			'' => 17
		}
	},
	{#State 7
		DEFAULT => -45
	},
	{#State 8
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			" " => 7,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 5
		},
		GOTOS => {
			'expr' => 19
		}
	},
	{#State 9
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			":->" => 31,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -1
	},
	{#State 10
		ACTIONS => {
			'NAME' => 41
		},
		GOTOS => {
			'arglist' => 42,
			'argelement' => 40
		}
	},
	{#State 11
		ACTIONS => {
			'NAME' => 43
		},
		DEFAULT => -15
	},
	{#State 12
		DEFAULT => -19
	},
	{#State 13
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 44
		}
	},
	{#State 14
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 45
		}
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 46,
			'expr' => 47
		}
	},
	{#State 16
		ACTIONS => {
			'NAME' => 41
		},
		GOTOS => {
			'arglist' => 48,
			'argelement' => 40
		}
	},
	{#State 17
		DEFAULT => 0
	},
	{#State 18
		ACTIONS => {
			"[" => 49,
			"=" => 14
		},
		DEFAULT => -16
	},
	{#State 19
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			")" => 50,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 51
		}
	},
	{#State 21
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 52
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 53
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 54
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 55
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 56
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 57
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 58
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 59
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 60
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 61
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 62
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 63
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 64
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 65
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 66
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 67
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 68
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 69
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 70
		}
	},
	{#State 40
		ACTIONS => {
			"," => 71
		},
		DEFAULT => -14
	},
	{#State 41
		ACTIONS => {
			"isa" => 74,
			"is" => 72,
			"=" => 73
		},
		DEFAULT => -9,
		GOTOS => {
			'isa' => 75
		}
	},
	{#State 42
		ACTIONS => {
			"]" => 76
		}
	},
	{#State 43
		DEFAULT => -21
	},
	{#State 44
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -3
	},
	{#State 45
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -20
	},
	{#State 46
		ACTIONS => {
			"]" => 77
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"," => 78,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"->" => 34,
			"/" => 35,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -6
	},
	{#State 48
		ACTIONS => {
			"|" => 79
		}
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 80,
			'expr' => 47
		}
	},
	{#State 50
		DEFAULT => -43
	},
	{#State 51
		ACTIONS => {
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			"/" => 35
		},
		DEFAULT => -24
	},
	{#State 52
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -34
	},
	{#State 53
		DEFAULT => -31
	},
	{#State 54
		ACTIONS => {
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			"/" => 35
		},
		DEFAULT => -23
	},
	{#State 55
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -29
	},
	{#State 56
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 57
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 58
		DEFAULT => -30
	},
	{#State 59
		ACTIONS => {
			"**" => 22,
			"^" => 27
		},
		DEFAULT => -25
	},
	{#State 60
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -26
	},
	{#State 61
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -28
	},
	{#State 62
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -4
	},
	{#State 63
		ACTIONS => {
			"-" => 20,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			"/" => 35
		},
		DEFAULT => -32
	},
	{#State 64
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 65
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -22
	},
	{#State 66
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -27
	},
	{#State 67
		ACTIONS => {
			"-" => 20,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			"/" => 35
		},
		DEFAULT => -33
	},
	{#State 68
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 69
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 70
		ACTIONS => {
			"-" => 20,
			"<" => undef,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => undef,
			">=" => undef,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => undef,
			"/" => 35,
			"<<" => 36,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -35
	},
	{#State 71
		ACTIONS => {
			'NAME' => 41
		},
		GOTOS => {
			'arglist' => 81,
			'argelement' => 40
		}
	},
	{#State 72
		ACTIONS => {
			" " => 82
		}
	},
	{#State 73
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 83
		}
	},
	{#State 74
		DEFAULT => -8
	},
	{#State 75
		ACTIONS => {
			'NAME' => 84
		}
	},
	{#State 76
		DEFAULT => -42
	},
	{#State 77
		ACTIONS => {
			":=" => 85
		},
		DEFAULT => -41
	},
	{#State 78
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 86,
			'expr' => 47
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 87
		}
	},
	{#State 80
		ACTIONS => {
			"]" => 88
		}
	},
	{#State 81
		DEFAULT => -13
	},
	{#State 82
		ACTIONS => {
			"a" => 89
		}
	},
	{#State 83
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -11
	},
	{#State 84
		ACTIONS => {
			"=" => 90
		},
		DEFAULT => -10
	},
	{#State 85
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 91
		}
	},
	{#State 86
		DEFAULT => -5
	},
	{#State 87
		ACTIONS => {
			"}" => 92,
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		}
	},
	{#State 88
		DEFAULT => -41
	},
	{#State 89
		DEFAULT => -7
	},
	{#State 90
		ACTIONS => {
			"-" => 1,
			'NAME' => 18,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 93
		}
	},
	{#State 91
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -2
	},
	{#State 92
		DEFAULT => -44
	},
	{#State 93
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			">>" => 32,
			"!=" => 33,
			"/" => 35,
			"->" => 34,
			"<<" => 36,
			"<=" => 38,
			"<=>" => 37,
			">" => 39
		},
		DEFAULT => -12
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'stmt', 1,
sub
#line 25 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 2
		 'stmt', 6,
sub
#line 26 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 3
		 'stmt', 3,
sub
#line 27 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 4
		 'stmt', 3,
sub
#line 28 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 5
		 'array', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 6
		 'array', 1, undef
	],
	[#Rule 7
		 'isa', 3, undef
	],
	[#Rule 8
		 'isa', 1, undef
	],
	[#Rule 9
		 'argelement', 1,
sub
#line 49 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 10
		 'argelement', 3,
sub
#line 50 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 11
		 'argelement', 3,
sub
#line 51 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 12
		 'argelement', 5,
sub
#line 52 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 13
		 'arglist', 3,
sub
#line 55 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 14
		 'arglist', 1, undef
	],
	[#Rule 15
		 'expr', 1,
sub
#line 60 "Farnsworth.yp"
{ bless [ $_[1] ],   'Num' }
	],
	[#Rule 16
		 'expr', 1,
sub
#line 61 "Farnsworth.yp"
{ bless [ $_[1] ],   'Fetch' }
	],
	[#Rule 17
		 'expr', 1,
sub
#line 62 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 18
		 'expr', 1,
sub
#line 63 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 19
		 'expr', 2,
sub
#line 64 "Farnsworth.yp"
{ bless [ (bless [ $_[2] ], 'Fetch') , '-1', '-name'], 'Mul' }
	],
	[#Rule 20
		 'expr', 3,
sub
#line 65 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 21
		 'expr', 2,
sub
#line 66 "Farnsworth.yp"
{ bless [ $_[1], (bless [ $_[2] ], 'Fetch' )], 'Mul' }
	],
	[#Rule 22
		 'expr', 3,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Trans' }
	],
	[#Rule 23
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 69 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3], ' '], 'Mul' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Bitreduce' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Bitexpand' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 41
		 'expr', 4,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 87 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 88 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 44
		 'expr', 6,
sub
#line 89 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 45
		 'expr', 1,
sub
#line 90 "Farnsworth.yp"
{undef}
	]
],
                                  @_);
    bless($self,$class);
}

#line 92 "Farnsworth.yp"


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
		{ $self->new(yylex => \&yylex, yyerror => \&yyerror, yydebug => 0x1F)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
