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
			'NUMBER' => 11
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
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 13
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 19,
			":=" => 14,
			"=!=" => 15,
			"::-" => 16,
			"=" => 17,
			":-" => 18
		},
		DEFAULT => -21
	},
	{#State 3
		ACTIONS => {
			'' => 20
		}
	},
	{#State 4
		DEFAULT => -22
	},
	{#State 5
		ACTIONS => {
			"|" => 21
		}
	},
	{#State 6
		DEFAULT => -23
	},
	{#State 7
		ACTIONS => {
			";" => 22
		},
		DEFAULT => -2
	},
	{#State 8
		DEFAULT => -50
	},
	{#State 9
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			" " => 8,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 23
		}
	},
	{#State 10
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			":->" => 35,
			"!=" => 36,
			"|||" => 37,
			"?" => 38,
			"/" => 40,
			"->" => 39,
			"(" => 41,
			"<=>" => 43,
			"<=" => 42,
			">" => 44
		},
		DEFAULT => -4
	},
	{#State 11
		ACTIONS => {
			'NAME' => 45
		},
		DEFAULT => -20
	},
	{#State 12
		ACTIONS => {
			"[" => 46,
			"::-" => 16,
			"=" => 17,
			":-" => 18
		},
		DEFAULT => -21
	},
	{#State 13
		ACTIONS => {
			"**" => 26,
			"%" => 28,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"/" => 40,
			"(" => 41
		},
		DEFAULT => -24
	},
	{#State 14
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 47
		}
	},
	{#State 15
		ACTIONS => {
			'NAME' => 48
		}
	},
	{#State 16
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 49
		}
	},
	{#State 17
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 50
		}
	},
	{#State 18
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 51
		}
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			'NAME' => 55,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'arglist' => 56,
			'array' => 53,
			'expr' => 54,
			'argelement' => 52
		}
	},
	{#State 20
		DEFAULT => 0
	},
	{#State 21
		ACTIONS => {
			'NAME' => 57
		},
		GOTOS => {
			'arglist' => 58,
			'argelement' => 52
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 59,
			'expr' => 10
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			")" => 60,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 61
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 62
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 63
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 64
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 65
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 66
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 67
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 68
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 69
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 70
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 71
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 72
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 73
		}
	},
	{#State 37
		ACTIONS => {
			'NAME' => 74
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 75
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 76
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 77
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 78
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 79
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 80
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 81
		}
	},
	{#State 45
		DEFAULT => -26
	},
	{#State 46
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 53,
			'expr' => 54
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -7
	},
	{#State 48
		DEFAULT => -10
	},
	{#State 49
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -43
	},
	{#State 50
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -25
	},
	{#State 51
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -44
	},
	{#State 52
		ACTIONS => {
			"," => 82
		},
		DEFAULT => -19
	},
	{#State 53
		ACTIONS => {
			"]" => 83
		}
	},
	{#State 54
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"," => 84,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -13
	},
	{#State 55
		ACTIONS => {
			"," => -17,
			"[" => 46,
			"]" => -17,
			"::-" => 16,
			"=" => 85,
			"isa" => 86,
			":-" => 18
		},
		DEFAULT => -21
	},
	{#State 56
		ACTIONS => {
			"]" => 87
		}
	},
	{#State 57
		ACTIONS => {
			"isa" => 86,
			"=" => 88
		},
		DEFAULT => -17
	},
	{#State 58
		ACTIONS => {
			"|" => 89
		}
	},
	{#State 59
		DEFAULT => -3
	},
	{#State 60
		DEFAULT => -47
	},
	{#State 61
		ACTIONS => {
			"**" => 26,
			"%" => 28,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"/" => 40,
			"(" => 41
		},
		DEFAULT => -28
	},
	{#State 62
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 63
		ACTIONS => {
			"(" => 41
		},
		DEFAULT => -35
	},
	{#State 64
		ACTIONS => {
			"**" => 26,
			"%" => 28,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"/" => 40,
			"(" => 41
		},
		DEFAULT => -27
	},
	{#State 65
		ACTIONS => {
			"**" => 26,
			"^" => 31,
			"(" => 41
		},
		DEFAULT => -33
	},
	{#State 66
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 67
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 68
		ACTIONS => {
			"(" => 41
		},
		DEFAULT => -34
	},
	{#State 69
		ACTIONS => {
			"**" => 26,
			"^" => 31,
			"(" => 41
		},
		DEFAULT => -29
	},
	{#State 70
		ACTIONS => {
			"**" => 26,
			"^" => 31,
			"(" => 41
		},
		DEFAULT => -30
	},
	{#State 71
		ACTIONS => {
			"**" => 26,
			"%" => 28,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"/" => 40,
			"(" => 41
		},
		DEFAULT => -32
	},
	{#State 72
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -9
	},
	{#State 73
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -42
	},
	{#State 74
		DEFAULT => -11
	},
	{#State 75
		ACTIONS => {
			":" => 90,
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		}
	},
	{#State 76
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -8
	},
	{#State 77
		ACTIONS => {
			"**" => 26,
			"^" => 31,
			"(" => 41
		},
		DEFAULT => -31
	},
	{#State 78
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			")" => 91,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 80
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -41
	},
	{#State 81
		ACTIONS => {
			"-" => 24,
			"<" => undef,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => undef,
			">=" => undef,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => undef,
			"/" => 40,
			"(" => 41,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 82
		ACTIONS => {
			'NAME' => 57
		},
		GOTOS => {
			'arglist' => 92,
			'argelement' => 52
		}
	},
	{#State 83
		DEFAULT => -46
	},
	{#State 84
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 93,
			'expr' => 54
		}
	},
	{#State 85
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 94
		}
	},
	{#State 86
		ACTIONS => {
			'NAME' => 95
		}
	},
	{#State 87
		ACTIONS => {
			":=" => 96
		}
	},
	{#State 88
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 97
		}
	},
	{#State 89
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 98
		}
	},
	{#State 90
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 99
		}
	},
	{#State 91
		DEFAULT => -48
	},
	{#State 92
		DEFAULT => -18
	},
	{#State 93
		DEFAULT => -12
	},
	{#State 94
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -16
	},
	{#State 95
		ACTIONS => {
			"=" => 100
		},
		DEFAULT => -15
	},
	{#State 96
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 102,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 101
		}
	},
	{#State 97
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -16
	},
	{#State 98
		ACTIONS => {
			"}" => 103,
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		}
	},
	{#State 99
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -45
	},
	{#State 100
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 104
		}
	},
	{#State 101
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -5
	},
	{#State 102
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			"|" => 21,
			" " => 8,
			"(" => 9,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 105,
			'expr' => 10
		}
	},
	{#State 103
		DEFAULT => -49
	},
	{#State 104
		ACTIONS => {
			"-" => 24,
			"<" => 25,
			"+" => 27,
			"**" => 26,
			"%" => 28,
			"==" => 29,
			">=" => 30,
			"^" => 31,
			" " => 32,
			"*" => 33,
			"per" => 34,
			"!=" => 36,
			"?" => 38,
			"/" => 40,
			"(" => 41,
			"<=" => 42,
			"<=>" => 43,
			">" => 44
		},
		DEFAULT => -14
	},
	{#State 105
		ACTIONS => {
			"}" => 106
		}
	},
	{#State 106
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
#line 91 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 48
		 'expr', 4,
sub
#line 92 "Farnsworth.yp"
{ bless [$_[1],(bless [$_[3]], 'Paren')], 'Mul' }
	],
	[#Rule 49
		 'expr', 6,
sub
#line 93 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 50
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
	$s =~ s/\A\s{2,}/ /; #don't need global?
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ s|\A\s*//.*||g;
	$s =~ s|\A\s*/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /^\s*((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/
	      and return 'NUMBER', $1;
	$s =~ /^\s*((\d+(\.\d*)?|\.\d+))/
	      and return 'NUMBER', $1;
    #$s =~ /^\s*(0[xX][0-9A-Fa-f])/ and return $1;

    #token out the date
    $s =~ /^\s*(#[^#]*#)\s*/ and return 'DATE', $1;

    if ($s =~ /^\s*"/) #"
	{
	   print "TEXT::BALANCED\n";
	   my ($e, $r) =  extract_delimited($s, '"');
	   print Dumper([$e, $r]);
	   $s = $r;
	   return 'STRING', $e
	}

#	$s =~ /\s*("([^\\"]*(?:\\.[^\\"]*)*)")\s*/gc and return 'STRING', $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /^\s*(:=|==|!=|>=|<=|->|:->|\*\*)\s*/i and return lc $1;
	$s =~ /^\s*(\bper\b|\bisa\b|\:?\:\-|\=\!\=|\|\|\|)\s*/i and return lc $1;
	$s =~ /^\s*(\+|\*|-|\/|\%|\^|=|;|\{|\}|\>|\<|\?|\:|\,)\s*/ and return $1;
	$s =~ /^\s*(\))/ and return $1; #freaking quirky lexers!
	$s =~ /^(\()\s*/ and return $1;
	$s =~ /^\s*(\w[\w\d]*)/ and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /^(.)/s and return $1;
    return '';
	}


sub yylexwatch
{
   my @r = &yylex;
   print Dumper(\@r,[pos $s]);
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
