####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Math::Farnsworth;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 8 "Farnsworth.yp"

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
		DEFAULT => -8
	},
	{#State 3
		DEFAULT => -9
	},
	{#State 4
		ACTIONS => {
			"|" => 16
		}
	},
	{#State 5
		DEFAULT => -10
	},
	{#State 6
		ACTIONS => {
			'' => 17
		}
	},
	{#State 7
		DEFAULT => -34
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
			":->" => 30,
			"!=" => 31,
			"->" => 32,
			"/" => 33,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
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
			'array' => 37,
			'expr' => 38
		}
	},
	{#State 11
		ACTIONS => {
			'NAME' => 39
		},
		DEFAULT => -7
	},
	{#State 12
		DEFAULT => -11
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
			'expr' => 40
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
			'expr' => 41
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
			'array' => 42,
			'expr' => 38
		}
	},
	{#State 16
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
			'array' => 43,
			'expr' => 38
		}
	},
	{#State 17
		DEFAULT => 0
	},
	{#State 18
		ACTIONS => {
			"[" => 44,
			"=" => 14
		},
		DEFAULT => -8
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
			")" => 45,
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
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
			'expr' => 46
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
			'expr' => 47
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
			'expr' => 48
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
			'expr' => 49
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
			'expr' => 50
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
			'expr' => 51
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
			'expr' => 52
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
			'expr' => 53
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
			'expr' => 54
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
			'expr' => 55
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
			'expr' => 56
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
			'expr' => 57
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
			'expr' => 58
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
			'expr' => 59
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
			'expr' => 60
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
			'expr' => 61
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
			'expr' => 62
		}
	},
	{#State 37
		ACTIONS => {
			"]" => 63
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 20,
			"<" => 21,
			"+" => 23,
			"**" => 22,
			"," => 64,
			"%" => 24,
			"==" => 25,
			">=" => 26,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		},
		DEFAULT => -6
	},
	{#State 39
		DEFAULT => -13
	},
	{#State 40
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
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		},
		DEFAULT => -3
	},
	{#State 41
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
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		},
		DEFAULT => -12
	},
	{#State 42
		ACTIONS => {
			"]" => 65
		}
	},
	{#State 43
		ACTIONS => {
			"|" => 66
		}
	},
	{#State 44
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
			'array' => 67,
			'expr' => 38
		}
	},
	{#State 45
		DEFAULT => -32
	},
	{#State 46
		ACTIONS => {
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"/" => 33
		},
		DEFAULT => -16
	},
	{#State 47
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -23
	},
	{#State 48
		DEFAULT => -22
	},
	{#State 49
		ACTIONS => {
			"**" => 22,
			"%" => 24,
			"^" => 27,
			" " => 28,
			"*" => 29,
			"/" => 33
		},
		DEFAULT => -15
	},
	{#State 50
		ACTIONS => {
			"**" => 22,
			"^" => 27
		},
		DEFAULT => -20
	},
	{#State 51
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -27
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -26
	},
	{#State 53
		DEFAULT => -21
	},
	{#State 54
		ACTIONS => {
			"**" => 22,
			"^" => 27
		},
		DEFAULT => -17
	},
	{#State 55
		ACTIONS => {
			"**" => 22,
			"^" => 27
		},
		DEFAULT => -18
	},
	{#State 56
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
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		},
		DEFAULT => -4
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -29
	},
	{#State 58
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
			"!=" => 31,
			"/" => 33,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		},
		DEFAULT => -14
	},
	{#State 59
		ACTIONS => {
			"**" => 22,
			"^" => 27
		},
		DEFAULT => -19
	},
	{#State 60
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -25
	},
	{#State 61
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -28
	},
	{#State 62
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
			"!=" => undef,
			"/" => 33,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -24
	},
	{#State 63
		DEFAULT => -31
	},
	{#State 64
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
			'array' => 68,
			'expr' => 38
		}
	},
	{#State 65
		ACTIONS => {
			":=" => 69
		},
		DEFAULT => -30
	},
	{#State 66
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
	{#State 67
		ACTIONS => {
			"]" => 71
		}
	},
	{#State 68
		DEFAULT => -5
	},
	{#State 69
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
	{#State 70
		ACTIONS => {
			"}" => 73,
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
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		}
	},
	{#State 71
		DEFAULT => -30
	},
	{#State 72
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
			"!=" => 31,
			"/" => 33,
			"->" => 32,
			"<=>" => 35,
			"<=" => 34,
			">" => 36
		},
		DEFAULT => -2
	},
	{#State 73
		DEFAULT => -33
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
#line 23 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 2
		 'stmt', 6,
sub
#line 24 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 3
		 'stmt', 3,
sub
#line 25 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 4
		 'stmt', 3,
sub
#line 26 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 5
		 'array', 3,
sub
#line 39 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 6
		 'array', 1, undef
	],
	[#Rule 7
		 'expr', 1,
sub
#line 44 "Farnsworth.yp"
{ bless [ $_[1] ],   'Num' }
	],
	[#Rule 8
		 'expr', 1,
sub
#line 45 "Farnsworth.yp"
{ bless [ $_[1] ],   'Fetch' }
	],
	[#Rule 9
		 'expr', 1,
sub
#line 46 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 10
		 'expr', 1,
sub
#line 47 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 11
		 'expr', 2,
sub
#line 48 "Farnsworth.yp"
{ bless [ (bless [ $_[2] ], 'Fetch') , '-1'], 'Mul' }
	],
	[#Rule 12
		 'expr', 3,
sub
#line 49 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 13
		 'expr', 2,
sub
#line 50 "Farnsworth.yp"
{ bless [ $_[1], (bless [ $_[2] ], 'Fetch' )], 'Mul' }
	],
	[#Rule 14
		 'expr', 3,
sub
#line 51 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Trans' }
	],
	[#Rule 15
		 'expr', 3,
sub
#line 52 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Add' }
	],
	[#Rule 16
		 'expr', 3,
sub
#line 53 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Sub' }
	],
	[#Rule 17
		 'expr', 3,
sub
#line 54 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mul' }
	],
	[#Rule 18
		 'expr', 3,
sub
#line 55 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mul' }
	],
	[#Rule 19
		 'expr', 3,
sub
#line 56 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Div' }
	],
	[#Rule 20
		 'expr', 3,
sub
#line 57 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 21
		 'expr', 3,
sub
#line 58 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 22
		 'expr', 3,
sub
#line 59 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 23
		 'expr', 3,
sub
#line 60 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 61 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 62 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 63 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 64 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 65 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 66 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 30
		 'expr', 4,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 69 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 33
		 'expr', 6,
sub
#line 70 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 34
		 'expr', 1,
sub
#line 71 "Farnsworth.yp"
{undef}
	]
],
                                  @_);
    bless($self,$class);
}

#line 73 "Farnsworth.yp"


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
	
	$s =~ /\G\s*(:=|==|!=|>=|<=|->|:->|\*\*)\s*/cg and return $1;
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


1;
