####################################################################
#
#    This file was generated using Parse::Yapp version 1.03.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package UP;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;

#line 8 "UP.y"

my $s;		# warning - not re-entrant


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.03',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'NAME' => 1,
			"for" => 2,
			"(" => 3,
			"while" => 4,
			";" => 7,
			'NUMBER' => 9,
			"print" => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 6,
			'while' => 8,
			'nosemi' => 11,
			'expr' => 12,
			'for' => 5
		}
	},
	{#State 1
		ACTIONS => {
			"=" => 13
		},
		DEFAULT => -22
	},
	{#State 2
		ACTIONS => {
			"(" => 14
		}
	},
	{#State 3
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 15
		}
	},
	{#State 4
		ACTIONS => {
			"(" => 16
		}
	},
	{#State 5
		DEFAULT => -7
	},
	{#State 6
		ACTIONS => {
			'' => 17
		}
	},
	{#State 7
		ACTIONS => {
			'NAME' => 1,
			"for" => 2,
			"(" => 3,
			"while" => 4,
			'NUMBER' => 9,
			";" => 7,
			"print" => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 18,
			'while' => 8,
			'nosemi' => 11,
			'expr' => 12,
			'for' => 5
		}
	},
	{#State 8
		DEFAULT => -6
	},
	{#State 9
		DEFAULT => -10
	},
	{#State 10
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 19
		}
	},
	{#State 11
		ACTIONS => {
			'NAME' => 1,
			"for" => 2,
			"(" => 3,
			"while" => 4,
			'NUMBER' => 9,
			";" => 7,
			"print" => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 20,
			'while' => 8,
			'nosemi' => 11,
			'expr' => 12,
			'for' => 5
		}
	},
	{#State 12
		ACTIONS => {
			"%" => 21,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			";" => 27,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		},
		DEFAULT => -2
	},
	{#State 13
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 33
		}
	},
	{#State 14
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 34
		}
	},
	{#State 15
		ACTIONS => {
			"%" => 21,
			")" => 35,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		}
	},
	{#State 16
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 36
		}
	},
	{#State 17
		DEFAULT => -0
	},
	{#State 18
		DEFAULT => -4
	},
	{#State 19
		ACTIONS => {
			"%" => 21,
			"*" => 24,
			"+" => 26,
			"-" => 29,
			"/" => 32
		},
		DEFAULT => -25
	},
	{#State 20
		DEFAULT => -5
	},
	{#State 21
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 37
		}
	},
	{#State 22
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 38
		}
	},
	{#State 23
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 39
		}
	},
	{#State 24
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 40
		}
	},
	{#State 25
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 41
		}
	},
	{#State 26
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 42
		}
	},
	{#State 27
		ACTIONS => {
			'NAME' => 1,
			"for" => 2,
			"(" => 3,
			"while" => 4,
			'NUMBER' => 9,
			";" => 7,
			"print" => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 43,
			'while' => 8,
			'nosemi' => 11,
			'expr' => 12,
			'for' => 5
		}
	},
	{#State 28
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 44
		}
	},
	{#State 29
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 45
		}
	},
	{#State 30
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 46
		}
	},
	{#State 31
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 47
		}
	},
	{#State 32
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 48
		}
	},
	{#State 33
		ACTIONS => {
			"%" => 21,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		},
		DEFAULT => -23
	},
	{#State 34
		ACTIONS => {
			"%" => 21,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			";" => 49,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		}
	},
	{#State 35
		DEFAULT => -24
	},
	{#State 36
		ACTIONS => {
			"%" => 21,
			")" => 50,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		}
	},
	{#State 37
		DEFAULT => -15
	},
	{#State 38
		ACTIONS => {
			"%" => 21,
			"<=" => undef,
			"==" => undef,
			"*" => 24,
			">=" => undef,
			"+" => 26,
			"<" => undef,
			"-" => 29,
			">" => undef,
			"!=" => undef,
			"/" => 32
		},
		DEFAULT => -18
	},
	{#State 39
		ACTIONS => {
			"%" => 21,
			"<=" => undef,
			"==" => undef,
			"*" => 24,
			">=" => undef,
			"+" => 26,
			"<" => undef,
			"-" => 29,
			">" => undef,
			"!=" => undef,
			"/" => 32
		},
		DEFAULT => -20
	},
	{#State 40
		DEFAULT => -13
	},
	{#State 41
		ACTIONS => {
			"%" => 21,
			"<=" => undef,
			"==" => undef,
			"*" => 24,
			">=" => undef,
			"+" => 26,
			"<" => undef,
			"-" => 29,
			">" => undef,
			"!=" => undef,
			"/" => 32
		},
		DEFAULT => -19
	},
	{#State 42
		ACTIONS => {
			"%" => 21,
			"*" => 24,
			"/" => 32
		},
		DEFAULT => -11
	},
	{#State 43
		DEFAULT => -3
	},
	{#State 44
		ACTIONS => {
			"%" => 21,
			"<=" => undef,
			"==" => undef,
			"*" => 24,
			">=" => undef,
			"+" => 26,
			"<" => undef,
			"-" => 29,
			">" => undef,
			"!=" => undef,
			"/" => 32
		},
		DEFAULT => -16
	},
	{#State 45
		ACTIONS => {
			"%" => 21,
			"*" => 24,
			"/" => 32
		},
		DEFAULT => -12
	},
	{#State 46
		ACTIONS => {
			"%" => 21,
			"<=" => undef,
			"==" => undef,
			"*" => 24,
			">=" => undef,
			"+" => 26,
			"<" => undef,
			"-" => 29,
			">" => undef,
			"!=" => undef,
			"/" => 32
		},
		DEFAULT => -21
	},
	{#State 47
		ACTIONS => {
			"%" => 21,
			"<=" => undef,
			"==" => undef,
			"*" => 24,
			">=" => undef,
			"+" => 26,
			"<" => undef,
			"-" => 29,
			">" => undef,
			"!=" => undef,
			"/" => 32
		},
		DEFAULT => -17
	},
	{#State 48
		DEFAULT => -14
	},
	{#State 49
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 51
		}
	},
	{#State 50
		ACTIONS => {
			"{" => 52
		}
	},
	{#State 51
		ACTIONS => {
			"%" => 21,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			";" => 53,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		}
	},
	{#State 52
		ACTIONS => {
			'NAME' => 1,
			"for" => 2,
			"(" => 3,
			"while" => 4,
			'NUMBER' => 9,
			";" => 7,
			"print" => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 54,
			'while' => 8,
			'nosemi' => 11,
			'expr' => 12,
			'for' => 5
		}
	},
	{#State 53
		ACTIONS => {
			'NUMBER' => 9,
			'NAME' => 1,
			"print" => 10,
			"(" => 3
		},
		GOTOS => {
			'expr' => 55
		}
	},
	{#State 54
		ACTIONS => {
			"}" => 56
		}
	},
	{#State 55
		ACTIONS => {
			"%" => 21,
			")" => 57,
			"<=" => 22,
			"==" => 23,
			"*" => 24,
			">=" => 25,
			"+" => 26,
			"<" => 28,
			"-" => 29,
			">" => 31,
			"!=" => 30,
			"/" => 32
		}
	},
	{#State 56
		DEFAULT => -9
	},
	{#State 57
		ACTIONS => {
			"{" => 58
		}
	},
	{#State 58
		ACTIONS => {
			'NAME' => 1,
			"for" => 2,
			"(" => 3,
			"while" => 4,
			'NUMBER' => 9,
			";" => 7,
			"print" => 10
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 59,
			'while' => 8,
			'nosemi' => 11,
			'expr' => 12,
			'for' => 5
		}
	},
	{#State 59
		ACTIONS => {
			"}" => 60
		}
	},
	{#State 60
		DEFAULT => -8
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'stmt', 0,
sub
#line 15 "UP.y"
{ bless [ ], 'Stmt' }
	],
	[#Rule 2
		 'stmt', 1,
sub
#line 16 "UP.y"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stmt', 3,
sub
#line 17 "UP.y"
{ bless [ $_[1], @{$_[3]} ], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 2,
sub
#line 18 "UP.y"
{ $_[2] }
	],
	[#Rule 5
		 'stmt', 2,
sub
#line 19 "UP.y"
{ bless [ $_[1], @{$_[2]} ], 'Stmt' }
	],
	[#Rule 6
		 'nosemi', 1, undef
	],
	[#Rule 7
		 'nosemi', 1, undef
	],
	[#Rule 8
		 'for', 11,
sub
#line 25 "UP.y"
{ bless [ @_[3,5,7,10] ], 'For' }
	],
	[#Rule 9
		 'while', 7,
sub
#line 29 "UP.y"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 10
		 'expr', 1,
sub
#line 33 "UP.y"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 11
		 'expr', 3,
sub
#line 34 "UP.y"
{ bless [ @_[1,3] ], 'Add' }
	],
	[#Rule 12
		 'expr', 3,
sub
#line 35 "UP.y"
{ bless [ @_[1,3] ], 'Sub' }
	],
	[#Rule 13
		 'expr', 3,
sub
#line 36 "UP.y"
{ bless [ @_[1,3] ], 'Mul' }
	],
	[#Rule 14
		 'expr', 3,
sub
#line 37 "UP.y"
{ bless [ @_[1,3] ], 'Div' }
	],
	[#Rule 15
		 'expr', 3,
sub
#line 38 "UP.y"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 16
		 'expr', 3,
sub
#line 39 "UP.y"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 17
		 'expr', 3,
sub
#line 40 "UP.y"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 18
		 'expr', 3,
sub
#line 41 "UP.y"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 19
		 'expr', 3,
sub
#line 42 "UP.y"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 20
		 'expr', 3,
sub
#line 43 "UP.y"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 21
		 'expr', 3,
sub
#line 44 "UP.y"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 22
		 'expr', 1,
sub
#line 45 "UP.y"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 23
		 'expr', 3,
sub
#line 46 "UP.y"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 47 "UP.y"
{ $_[2] }
	],
	[#Rule 25
		 'expr', 2,
sub
#line 48 "UP.y"
{ bless [ $_[2] ], 'Print' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 50 "UP.y"


sub yylex
	{
	1 while $s =~ /\G\s+/cg;
	$s =~ /\G(\d+(?:\.\d*)?)/cg and return 'NUMBER', $1;
	$s =~ /\G(\.\d+)/cg and return 'NUMBER', $1;
	$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	$s =~ /\G(\+\+|==|!=|>=|<=)/cg and return $1;
	$s =~ /\G(\w+)/cg and return 'NAME', $1;
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
	my $self = shift;
	$s = join ' ', @_;
	my $code = eval
		{ $self->new(yylex => \&yylex, yyerror => \&yyerror)->YYParse };
	die $@ if $@;
	$code
	}

1;

1;
