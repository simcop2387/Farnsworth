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
		DEFAULT => -14
	},
	{#State 3
		DEFAULT => -15
	},
	{#State 4
		ACTIONS => {
			"|" => 16
		}
	},
	{#State 5
		DEFAULT => -16
	},
	{#State 6
		ACTIONS => {
			'' => 17
		}
	},
	{#State 7
		DEFAULT => -43
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
			'array' => 40,
			'expr' => 41
		}
	},
	{#State 11
		ACTIONS => {
			'NAME' => 42
		},
		DEFAULT => -13
	},
	{#State 12
		DEFAULT => -17
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
			'expr' => 43
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
			'expr' => 44
		}
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 47,
			'DATE' => 3,
			"{" => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'arglist' => 48,
			'array' => 46,
			'expr' => 41,
			'argelement' => 45
		}
	},
	{#State 16
		ACTIONS => {
			'NAME' => 49
		},
		GOTOS => {
			'arglist' => 50,
			'argelement' => 45
		}
	},
	{#State 17
		DEFAULT => 0
	},
	{#State 18
		ACTIONS => {
			"[" => 51,
			"=" => 14
		},
		DEFAULT => -14
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
			")" => 52,
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
			'expr' => 53
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
			'expr' => 54
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
			'expr' => 55
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
			'expr' => 56
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
			'expr' => 57
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
			'expr' => 58
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
			'expr' => 59
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
			'expr' => 60
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
			'expr' => 61
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
			'expr' => 62
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
			'expr' => 63
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
			'expr' => 64
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
			'expr' => 65
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
			'expr' => 66
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
			'expr' => 67
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
			'expr' => 68
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
			'expr' => 69
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
			'expr' => 70
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
			'expr' => 71
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
			'expr' => 72
		}
	},
	{#State 40
		ACTIONS => {
			"]" => 73
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"," => 74,
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
	{#State 42
		DEFAULT => -19
	},
	{#State 43
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
		DEFAULT => -18
	},
	{#State 45
		ACTIONS => {
			"," => 75
		},
		DEFAULT => -12
	},
	{#State 46
		ACTIONS => {
			"]" => 76
		}
	},
	{#State 47
		ACTIONS => {
			"," => -10,
			"[" => 51,
			"]" => -10,
			"=" => 77,
			"isa" => 78
		},
		DEFAULT => -14
	},
	{#State 48
		ACTIONS => {
			"]" => 79
		}
	},
	{#State 49
		ACTIONS => {
			"isa" => 78,
			"=" => 80
		},
		DEFAULT => -10
	},
	{#State 50
		ACTIONS => {
			"|" => 81
		}
	},
	{#State 51
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
			'expr' => 41
		}
	},
	{#State 52
		DEFAULT => -41
	},
	{#State 53
		ACTIONS => {
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			"/" => 35
		},
		DEFAULT => -22
	},
	{#State 54
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
		DEFAULT => -32
	},
	{#State 55
		DEFAULT => -29
	},
	{#State 56
		ACTIONS => {
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"per" => 30,
			"/" => 35
		},
		DEFAULT => -21
	},
	{#State 57
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -27
	},
	{#State 58
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
	{#State 59
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
	{#State 60
		DEFAULT => -28
	},
	{#State 61
		ACTIONS => {
			"**" => 22,
			"^" => 27
		},
		DEFAULT => -23
	},
	{#State 62
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -24
	},
	{#State 63
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -26
	},
	{#State 64
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
	{#State 65
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
		DEFAULT => -30
	},
	{#State 66
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
	{#State 67
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
		DEFAULT => -20
	},
	{#State 68
		ACTIONS => {
			"**" => 22,
			"^" => 27,
			" " => 28
		},
		DEFAULT => -25
	},
	{#State 69
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
		DEFAULT => -31
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
		DEFAULT => -37
	},
	{#State 71
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
	{#State 72
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
		DEFAULT => -33
	},
	{#State 73
		DEFAULT => -40
	},
	{#State 74
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
			'array' => 82,
			'expr' => 41
		}
	},
	{#State 75
		ACTIONS => {
			'NAME' => 49
		},
		GOTOS => {
			'arglist' => 83,
			'argelement' => 45
		}
	},
	{#State 76
		DEFAULT => -39
	},
	{#State 77
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
			'expr' => 84
		}
	},
	{#State 78
		ACTIONS => {
			'NAME' => 85
		}
	},
	{#State 79
		ACTIONS => {
			":=" => 86
		}
	},
	{#State 80
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
	{#State 81
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
			'expr' => 88
		}
	},
	{#State 82
		DEFAULT => -5
	},
	{#State 83
		DEFAULT => -11
	},
	{#State 84
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
		DEFAULT => -9
	},
	{#State 85
		ACTIONS => {
			"=" => 89
		},
		DEFAULT => -8
	},
	{#State 86
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
			'expr' => 90
		}
	},
	{#State 87
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
		DEFAULT => -9
	},
	{#State 88
		ACTIONS => {
			"}" => 91,
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
	{#State 89
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
			'expr' => 92
		}
	},
	{#State 90
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
	{#State 91
		DEFAULT => -42
	},
	{#State 92
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
		DEFAULT => -7
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
		 'argelement', 5,
sub
#line 45 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 8
		 'argelement', 3,
sub
#line 46 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 9
		 'argelement', 3,
sub
#line 47 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 10
		 'argelement', 1,
sub
#line 48 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 11
		 'arglist', 3,
sub
#line 51 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 12
		 'arglist', 1, undef
	],
	[#Rule 13
		 'expr', 1,
sub
#line 56 "Farnsworth.yp"
{ bless [ $_[1] ],   'Num' }
	],
	[#Rule 14
		 'expr', 1,
sub
#line 57 "Farnsworth.yp"
{ bless [ $_[1] ],   'Fetch' }
	],
	[#Rule 15
		 'expr', 1,
sub
#line 58 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 16
		 'expr', 1,
sub
#line 59 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 17
		 'expr', 2,
sub
#line 60 "Farnsworth.yp"
{ bless [ (bless [ $_[2] ], 'Fetch') , '-1', '-name'], 'Mul' }
	],
	[#Rule 18
		 'expr', 3,
sub
#line 61 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 19
		 'expr', 2,
sub
#line 62 "Farnsworth.yp"
{ bless [ $_[1], (bless [ $_[2] ], 'Fetch' )], 'Mul' }
	],
	[#Rule 20
		 'expr', 3,
sub
#line 63 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Trans' }
	],
	[#Rule 21
		 'expr', 3,
sub
#line 64 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 22
		 'expr', 3,
sub
#line 65 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 23
		 'expr', 3,
sub
#line 66 "Farnsworth.yp"
{ bless [ @_[1,3], ' '], 'Mul' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 69 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Bitreduce' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Bitexpand' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 39
		 'expr', 4,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 42
		 'expr', 6,
sub
#line 85 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 43
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
		{ $self->new(yylex => \&yylex, yyerror => \&yyerror, yydebug => 0x1F)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
