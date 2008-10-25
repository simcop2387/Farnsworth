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
#Included Parse/Yapp/Driver.pm file----------------------------------------
{
#
# Module Parse::Yapp::Driver
#
# This module is part of the Parse::Yapp package available on your
# nearest CPAN
#
# Any use of this module in a standalone parser make the included
# text under the same copyright as the Parse::Yapp module itself.
#
# This notice should remain unchanged.
#
# (c) Copyright 1998-2001 Francois Desarmenien, all rights reserved.
# (see the pod text in Parse::Yapp module for use and distribution rights)
#

package Parse::Yapp::Driver;

require 5.004;

use strict;

use vars qw ( $VERSION $COMPATIBLE $FILENAME );

$VERSION = '1.05';
$COMPATIBLE = '0.07';
$FILENAME=__FILE__;

use Carp;

#Known parameters, all starting with YY (leading YY will be discarded)
my(%params)=(YYLEX => 'CODE', 'YYERROR' => 'CODE', YYVERSION => '',
			 YYRULES => 'ARRAY', YYSTATES => 'ARRAY', YYDEBUG => '');
#Mandatory parameters
my(@params)=('LEX','RULES','STATES');

sub new {
    my($class)=shift;
	my($errst,$nberr,$token,$value,$check,$dotpos);
    my($self)={ ERROR => \&_Error,
				ERRST => \$errst,
                NBERR => \$nberr,
				TOKEN => \$token,
				VALUE => \$value,
				DOTPOS => \$dotpos,
				STACK => [],
				DEBUG => 0,
				CHECK => \$check };

	_CheckParams( [], \%params, \@_, $self );

		exists($$self{VERSION})
	and	$$self{VERSION} < $COMPATIBLE
	and	croak "Yapp driver version $VERSION ".
			  "incompatible with version $$self{VERSION}:\n".
			  "Please recompile parser module.";

        ref($class)
    and $class=ref($class);

    bless($self,$class);
}

sub YYParse {
    my($self)=shift;
    my($retval);

	_CheckParams( \@params, \%params, \@_, $self );

	if($$self{DEBUG}) {
		_DBLoad();
		$retval = eval '$self->_DBParse()';#Do not create stab entry on compile
        $@ and die $@;
	}
	else {
		$retval = $self->_Parse();
	}
    $retval
}

sub YYData {
	my($self)=shift;

		exists($$self{USER})
	or	$$self{USER}={};

	$$self{USER};
	
}

sub YYErrok {
	my($self)=shift;

	${$$self{ERRST}}=0;
    undef;
}

sub YYNberr {
	my($self)=shift;

	${$$self{NBERR}};
}

sub YYRecovering {
	my($self)=shift;

	${$$self{ERRST}} != 0;
}

sub YYAbort {
	my($self)=shift;

	${$$self{CHECK}}='ABORT';
    undef;
}

sub YYAccept {
	my($self)=shift;

	${$$self{CHECK}}='ACCEPT';
    undef;
}

sub YYError {
	my($self)=shift;

	${$$self{CHECK}}='ERROR';
    undef;
}

sub YYSemval {
	my($self)=shift;
	my($index)= $_[0] - ${$$self{DOTPOS}} - 1;

		$index < 0
	and	-$index <= @{$$self{STACK}}
	and	return $$self{STACK}[$index][1];

	undef;	#Invalid index
}

sub YYCurtok {
	my($self)=shift;

        @_
    and ${$$self{TOKEN}}=$_[0];
    ${$$self{TOKEN}};
}

sub YYCurval {
	my($self)=shift;

        @_
    and ${$$self{VALUE}}=$_[0];
    ${$$self{VALUE}};
}

sub YYExpect {
    my($self)=shift;

    keys %{$self->{STATES}[$self->{STACK}[-1][0]]{ACTIONS}}
}

sub YYLexer {
    my($self)=shift;

	$$self{LEX};
}


#################
# Private stuff #
#################


sub _CheckParams {
	my($mandatory,$checklist,$inarray,$outhash)=@_;
	my($prm,$value);
	my($prmlst)={};

	while(($prm,$value)=splice(@$inarray,0,2)) {
        $prm=uc($prm);
			exists($$checklist{$prm})
		or	croak("Unknow parameter '$prm'");
			ref($value) eq $$checklist{$prm}
		or	croak("Invalid value for parameter '$prm'");
        $prm=unpack('@2A*',$prm);
		$$outhash{$prm}=$value;
	}
	for (@$mandatory) {
			exists($$outhash{$_})
		or	croak("Missing mandatory parameter '".lc($_)."'");
	}
}

sub _Error {
	print "Parse error.\n";
}

sub _DBLoad {
	{
		no strict 'refs';

			exists(${__PACKAGE__.'::'}{_DBParse})#Already loaded ?
		and	return;
	}
	my($fname)=__FILE__;
	my(@drv);
	open(DRV,"<$fname") or die "Report this as a BUG: Cannot open $fname";
	while(<DRV>) {
                	/^\s*sub\s+_Parse\s*{\s*$/ .. /^\s*}\s*#\s*_Parse\s*$/
        	and     do {
                	s/^#DBG>//;
                	push(@drv,$_);
        	}
	}
	close(DRV);

	$drv[0]=~s/_P/_DBP/;
	eval join('',@drv);
}

#Note that for loading debugging version of the driver,
#this file will be parsed from 'sub _Parse' up to '}#_Parse' inclusive.
#So, DO NOT remove comment at end of sub !!!
sub _Parse {
    my($self)=shift;

	my($rules,$states,$lex,$error)
     = @$self{ 'RULES', 'STATES', 'LEX', 'ERROR' };
	my($errstatus,$nberror,$token,$value,$stack,$check,$dotpos)
     = @$self{ 'ERRST', 'NBERR', 'TOKEN', 'VALUE', 'STACK', 'CHECK', 'DOTPOS' };

#DBG>	my($debug)=$$self{DEBUG};
#DBG>	my($dbgerror)=0;

#DBG>	my($ShowCurToken) = sub {
#DBG>		my($tok)='>';
#DBG>		for (split('',$$token)) {
#DBG>			$tok.=		(ord($_) < 32 or ord($_) > 126)
#DBG>					?	sprintf('<%02X>',ord($_))
#DBG>					:	$_;
#DBG>		}
#DBG>		$tok.='<';
#DBG>	};

	$$errstatus=0;
	$$nberror=0;
	($$token,$$value)=(undef,undef);
	@$stack=( [ 0, undef ] );
	$$check='';

    while(1) {
        my($actions,$act,$stateno);

        $stateno=$$stack[-1][0];
        $actions=$$states[$stateno];

#DBG>	print STDERR ('-' x 40),"\n";
#DBG>		$debug & 0x2
#DBG>	and	print STDERR "In state $stateno:\n";
#DBG>		$debug & 0x08
#DBG>	and	print STDERR "Stack:[".
#DBG>					 join(',',map { $$_[0] } @$stack).
#DBG>					 "]\n";


        if  (exists($$actions{ACTIONS})) {

				defined($$token)
            or	do {
				($$token,$$value)=&$lex($self);
#DBG>				$debug & 0x01
#DBG>			and	print STDERR "Need token. Got ".&$ShowCurToken."\n";
			};

            $act=   exists($$actions{ACTIONS}{$$token})
                    ?   $$actions{ACTIONS}{$$token}
                    :   exists($$actions{DEFAULT})
                        ?   $$actions{DEFAULT}
                        :   undef;
        }
        else {
            $act=$$actions{DEFAULT};
#DBG>			$debug & 0x01
#DBG>		and	print STDERR "Don't need token.\n";
        }

            defined($act)
        and do {

                $act > 0
            and do {        #shift

#DBG>				$debug & 0x04
#DBG>			and	print STDERR "Shift and go to state $act.\n";

					$$errstatus
				and	do {
					--$$errstatus;

#DBG>					$debug & 0x10
#DBG>				and	$dbgerror
#DBG>				and	$$errstatus == 0
#DBG>				and	do {
#DBG>					print STDERR "**End of Error recovery.\n";
#DBG>					$dbgerror=0;
#DBG>				};
				};


                push(@$stack,[ $act, $$value ]);

					$$token ne ''	#Don't eat the eof
				and	$$token=$$value=undef;
                next;
            };

            #reduce
            my($lhs,$len,$code,@sempar,$semval);
            ($lhs,$len,$code)=@{$$rules[-$act]};

#DBG>			$debug & 0x04
#DBG>		and	$act
#DBG>		and	print STDERR "Reduce using rule ".-$act." ($lhs,$len): ";

                $act
            or  $self->YYAccept();

            $$dotpos=$len;

                unpack('A1',$lhs) eq '@'    #In line rule
            and do {
                    $lhs =~ /^\@[0-9]+\-([0-9]+)$/
                or  die "In line rule name '$lhs' ill formed: ".
                        "report it as a BUG.\n";
                $$dotpos = $1;
            };

            @sempar =       $$dotpos
                        ?   map { $$_[1] } @$stack[ -$$dotpos .. -1 ]
                        :   ();

            $semval = $code ? &$code( $self, @sempar )
                            : @sempar ? $sempar[0] : undef;

            splice(@$stack,-$len,$len);

                $$check eq 'ACCEPT'
            and do {

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Accept.\n";

				return($semval);
			};

                $$check eq 'ABORT'
            and	do {

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Abort.\n";

				return(undef);

			};

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Back to state $$stack[-1][0], then ";

                $$check eq 'ERROR'
            or  do {
#DBG>				$debug & 0x04
#DBG>			and	print STDERR 
#DBG>				    "go to state $$states[$$stack[-1][0]]{GOTOS}{$lhs}.\n";

#DBG>				$debug & 0x10
#DBG>			and	$dbgerror
#DBG>			and	$$errstatus == 0
#DBG>			and	do {
#DBG>				print STDERR "**End of Error recovery.\n";
#DBG>				$dbgerror=0;
#DBG>			};

			    push(@$stack,
                     [ $$states[$$stack[-1][0]]{GOTOS}{$lhs}, $semval ]);
                $$check='';
                next;
            };

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Forced Error recovery.\n";

            $$check='';

        };

        #Error
            $$errstatus
        or   do {

            $$errstatus = 1;
            &$error($self);
                $$errstatus # if 0, then YYErrok has been called
            or  next;       # so continue parsing

#DBG>			$debug & 0x10
#DBG>		and	do {
#DBG>			print STDERR "**Entering Error recovery.\n";
#DBG>			++$dbgerror;
#DBG>		};

            ++$$nberror;

        };

			$$errstatus == 3	#The next token is not valid: discard it
		and	do {
				$$token eq ''	# End of input: no hope
			and	do {
#DBG>				$debug & 0x10
#DBG>			and	print STDERR "**At eof: aborting.\n";
				return(undef);
			};

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Dicard invalid token ".&$ShowCurToken.".\n";

			$$token=$$value=undef;
		};

        $$errstatus=3;

		while(	  @$stack
			  and (		not exists($$states[$$stack[-1][0]]{ACTIONS})
			        or  not exists($$states[$$stack[-1][0]]{ACTIONS}{error})
					or	$$states[$$stack[-1][0]]{ACTIONS}{error} <= 0)) {

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Pop state $$stack[-1][0].\n";

			pop(@$stack);
		}

			@$stack
		or	do {

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**No state left on stack: aborting.\n";

			return(undef);
		};

		#shift the error token

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Shift \$error token and go to state ".
#DBG>						 $$states[$$stack[-1][0]]{ACTIONS}{error}.
#DBG>						 ".\n";

		push(@$stack, [ $$states[$$stack[-1][0]]{ACTIONS}{error}, undef ]);

    }

    #never reached
	croak("Error in driver logic. Please, report it as a BUG");

}#_Parse
#DO NOT remove comment

1;

}
#End of include--------------------------------------------------


#line 19 "Farnsworth.yp"

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
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			"(" => 24,
			'HEXNUMBER' => 23,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 15,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 25,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 2
		DEFAULT => -50
	},
	{#State 3
		DEFAULT => -88
	},
	{#State 4
		ACTIONS => {
			"=" => 27
		},
		DEFAULT => -51
	},
	{#State 5
		DEFAULT => -90
	},
	{#State 6
		DEFAULT => -89
	},
	{#State 7
		DEFAULT => -12
	},
	{#State 8
		DEFAULT => -49
	},
	{#State 9
		ACTIONS => {
			"(" => 28
		}
	},
	{#State 10
		ACTIONS => {
			'HEXNUMBER' => 23,
			"(" => 24,
			'NAME' => 30,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'exprval' => 31,
			'arrayfetchexpr' => 29
		}
	},
	{#State 11
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			":->" => 44,
			"!=" => 45,
			"|||" => 46,
			"?" => 49,
			"&&" => 48,
			"||" => 47,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -5
	},
	{#State 12
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 57,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 58,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 59,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 13
		DEFAULT => -44
	},
	{#State 14
		ACTIONS => {
			"[" => 60,
			"::-" => 64,
			":=" => 61,
			"=!=" => 63,
			"{" => 62,
			"=" => 65,
			":-" => 66
		},
		DEFAULT => -46
	},
	{#State 15
		ACTIONS => {
			'' => 67
		}
	},
	{#State 16
		ACTIONS => {
			"\@" => 68,
			'HEXNUMBER' => 23,
			"(" => 24,
			'NUMBER' => 13,
			'NAME' => 30
		},
		DEFAULT => -54,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'exprval' => 69,
			'arrayfetchexpr' => 29
		}
	},
	{#State 17
		ACTIONS => {
			'NAME' => 71
		},
		GOTOS => {
			'assignexpr' => 70
		}
	},
	{#State 18
		ACTIONS => {
			"`" => 72
		}
	},
	{#State 19
		ACTIONS => {
			"\n" => 73,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 75
		}
	},
	{#State 20
		ACTIONS => {
			"(" => 76
		}
	},
	{#State 21
		ACTIONS => {
			"\n" => 78,
			";" => 77
		},
		DEFAULT => -2
	},
	{#State 22
		DEFAULT => -13
	},
	{#State 23
		DEFAULT => -45
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 79,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 25
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -55
	},
	{#State 26
		ACTIONS => {
			"[" => 60,
			"::-" => 64,
			"{" => 62,
			"=" => 65,
			":-" => 66
		},
		DEFAULT => -46
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 80,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 81,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 29
		DEFAULT => -51
	},
	{#State 30
		ACTIONS => {
			"[" => 60
		},
		DEFAULT => -46
	},
	{#State 31
		ACTIONS => {
			"\@" => 68
		},
		DEFAULT => -71
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 82,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 83,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 84,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 85,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 86,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 87,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 88,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 89,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 90,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 91,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 92,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 93,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 94,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 95,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 46
		ACTIONS => {
			'NAME' => 96
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 97,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 98,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 99,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 100,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 51
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 101,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 52
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 102,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 53
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 103,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 54
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 104,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 55
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 105,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 56
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 106,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 57
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 57,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 107,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 59,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 58
		ACTIONS => {
			"]" => 108
		}
	},
	{#State 59
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"," => 109,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"&&" => 48,
			"||" => 47,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -28
	},
	{#State 60
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 110,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -34,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 111,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'argarray' => 112,
			'assignexpr' => 5
		}
	},
	{#State 61
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 113,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 62
		ACTIONS => {
			'NAME' => 115
		},
		DEFAULT => -41,
		GOTOS => {
			'arglist' => 116,
			'argelement' => 114
		}
	},
	{#State 63
		ACTIONS => {
			'NAME' => 117
		}
	},
	{#State 64
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 118,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 65
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 119,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 66
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 120,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 67
		DEFAULT => 0
	},
	{#State 68
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 57,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 121,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 59,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 69
		ACTIONS => {
			"\@" => 68
		},
		DEFAULT => -60
	},
	{#State 70
		DEFAULT => -7
	},
	{#State 71
		ACTIONS => {
			"=" => 65
		},
		DEFAULT => -6
	},
	{#State 72
		ACTIONS => {
			'NAME' => 115
		},
		DEFAULT => -41,
		GOTOS => {
			'arglist' => 122,
			'argelement' => 114
		}
	},
	{#State 73
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 123
		}
	},
	{#State 74
		ACTIONS => {
			"-" => 1,
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 124,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 75
		ACTIONS => {
			"else" => 125
		},
		DEFAULT => -16
	},
	{#State 76
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 127,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 77
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 6,
			"if" => 9,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13,
			'NAME' => 14,
			"var" => 17,
			"{" => 18,
			"while" => 20,
			"(" => 24,
			'HEXNUMBER' => 23
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 128,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 78
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 6,
			"if" => 9,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13,
			'NAME' => 14,
			"var" => 17,
			"{" => 18,
			"while" => 20,
			"(" => 24,
			'HEXNUMBER' => 23
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 129,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			")" => 130,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		}
	},
	{#State 80
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -86
	},
	{#State 81
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			")" => 131,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		}
	},
	{#State 82
		ACTIONS => {
			"%" => 37,
			" " => 41,
			"*" => 42,
			"**" => 35,
			"^" => 40,
			"per" => 43,
			"/" => 52
		},
		DEFAULT => -58
	},
	{#State 83
		ACTIONS => {
			"-" => 32,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -66
	},
	{#State 84
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -72
	},
	{#State 85
		DEFAULT => -65
	},
	{#State 86
		ACTIONS => {
			"%" => 37,
			" " => 41,
			"*" => 42,
			"**" => 35,
			"^" => 40,
			"per" => 43,
			"/" => 52
		},
		DEFAULT => -57
	},
	{#State 87
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -63
	},
	{#State 88
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -76
	},
	{#State 89
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -75
	},
	{#State 90
		DEFAULT => -64
	},
	{#State 91
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -56
	},
	{#State 92
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -59
	},
	{#State 93
		ACTIONS => {
			"%" => 37,
			" " => 41,
			"*" => 42,
			"**" => 35,
			"^" => 40,
			"/" => 52
		},
		DEFAULT => -62
	},
	{#State 94
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -9
	},
	{#State 95
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -78
	},
	{#State 96
		DEFAULT => -11
	},
	{#State 97
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -69
	},
	{#State 98
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -68
	},
	{#State 99
		ACTIONS => {
			":" => 132,
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		}
	},
	{#State 100
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -70
	},
	{#State 101
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -87
	},
	{#State 102
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -61
	},
	{#State 103
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -85
	},
	{#State 104
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -77
	},
	{#State 105
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -74
	},
	{#State 106
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -73
	},
	{#State 107
		DEFAULT => -30
	},
	{#State 108
		DEFAULT => -83
	},
	{#State 109
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 57,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -29,
		GOTOS => {
			'array' => 133,
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 59,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 110
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 110,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -34,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 111,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'argarray' => 134,
			'assignexpr' => 5
		}
	},
	{#State 111
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"," => 135,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"&&" => 48,
			"||" => 47,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -33
	},
	{#State 112
		ACTIONS => {
			"]" => 136
		}
	},
	{#State 113
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -8
	},
	{#State 114
		ACTIONS => {
			"," => 137
		},
		DEFAULT => -43
	},
	{#State 115
		ACTIONS => {
			"isa" => 139,
			"=" => 138
		},
		DEFAULT => -40
	},
	{#State 116
		ACTIONS => {
			"}" => 140
		}
	},
	{#State 117
		DEFAULT => -10
	},
	{#State 118
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -79
	},
	{#State 119
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -52
	},
	{#State 120
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -80
	},
	{#State 121
		ACTIONS => {
			"\$" => 141
		}
	},
	{#State 122
		ACTIONS => {
			"`" => 142
		}
	},
	{#State 123
		ACTIONS => {
			"else" => 143
		},
		DEFAULT => -18
	},
	{#State 124
		ACTIONS => {
			"}" => 145
		}
	},
	{#State 125
		ACTIONS => {
			"\n" => 146,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 147
		}
	},
	{#State 126
		ACTIONS => {
			"else" => 148
		}
	},
	{#State 127
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			")" => 149,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		}
	},
	{#State 128
		DEFAULT => -3
	},
	{#State 129
		DEFAULT => -4
	},
	{#State 130
		DEFAULT => -47
	},
	{#State 131
		DEFAULT => -14
	},
	{#State 132
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 150,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 133
		DEFAULT => -27
	},
	{#State 134
		DEFAULT => -32
	},
	{#State 135
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"," => 110,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -34,
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 111,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'argarray' => 151,
			'assignexpr' => 5
		}
	},
	{#State 136
		DEFAULT => -48
	},
	{#State 137
		ACTIONS => {
			'NAME' => 115
		},
		DEFAULT => -41,
		GOTOS => {
			'arglist' => 152,
			'argelement' => 114
		}
	},
	{#State 138
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 153,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 139
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"..." => 156,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 154,
			'exprval' => 16,
			'constraint' => 155,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 140
		ACTIONS => {
			":=" => 157
		}
	},
	{#State 141
		DEFAULT => -53
	},
	{#State 142
		ACTIONS => {
			"-" => 1,
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 158,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 143
		ACTIONS => {
			"\n" => 159,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 160
		}
	},
	{#State 144
		ACTIONS => {
			"else" => 161
		}
	},
	{#State 145
		DEFAULT => -15
	},
	{#State 146
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 162
		}
	},
	{#State 147
		DEFAULT => -17
	},
	{#State 148
		ACTIONS => {
			"\n" => 163,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 164
		}
	},
	{#State 149
		ACTIONS => {
			"{" => 165
		}
	},
	{#State 150
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -67
	},
	{#State 151
		DEFAULT => -31
	},
	{#State 152
		DEFAULT => -42
	},
	{#State 153
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"isa" => 166,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -39
	},
	{#State 154
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			"<=>" => 54,
			">" => 56
		},
		DEFAULT => -35
	},
	{#State 155
		DEFAULT => -38
	},
	{#State 156
		DEFAULT => -36
	},
	{#State 157
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 168,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"!" => 10,
			"(" => 24,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 167,
			'exprval' => 16,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 158
		ACTIONS => {
			"}" => 169
		}
	},
	{#State 159
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 170
		}
	},
	{#State 160
		DEFAULT => -19
	},
	{#State 161
		ACTIONS => {
			"\n" => 171,
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 172
		}
	},
	{#State 162
		DEFAULT => -24
	},
	{#State 163
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 173
		}
	},
	{#State 164
		DEFAULT => -23
	},
	{#State 165
		ACTIONS => {
			"-" => 1,
			'NAME' => 14,
			"var" => 17,
			'DATE' => 3,
			"{" => 18,
			"while" => 20,
			'STRING' => 6,
			"if" => 9,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 174,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 166
		ACTIONS => {
			"-" => 1,
			'NAME' => 26,
			'DATE' => 3,
			"{" => 18,
			"..." => 156,
			'STRING' => 6,
			'HEXNUMBER' => 23,
			"(" => 24,
			"!" => 10,
			"[" => 12,
			'NUMBER' => 13
		},
		GOTOS => {
			'exprval1' => 8,
			'exprval2' => 2,
			'expr' => 154,
			'exprval' => 16,
			'constraint' => 175,
			'arrayfetchexpr' => 4,
			'assignexpr' => 5
		}
	},
	{#State 167
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 53,
			"<=" => 55,
			">" => 56,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 54
		},
		DEFAULT => -81
	},
	{#State 168
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 6,
			"if" => 9,
			"!" => 10,
			"`" => 72,
			"[" => 12,
			'NUMBER' => 13,
			'NAME' => 14,
			"var" => 17,
			"{" => 18,
			"while" => 20,
			"(" => 24,
			'HEXNUMBER' => 23
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 176,
			'exprval' => 16,
			'ifstartcond' => 19,
			'arrayfetchexpr' => 4,
			'if' => 7,
			'assignexpr' => 5,
			'exprval1' => 8,
			'stmt' => 21,
			'while' => 22,
			'expr' => 11
		}
	},
	{#State 169
		DEFAULT => -84
	},
	{#State 170
		DEFAULT => -21
	},
	{#State 171
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 177
		}
	},
	{#State 172
		DEFAULT => -20
	},
	{#State 173
		DEFAULT => -25
	},
	{#State 174
		ACTIONS => {
			"}" => 178
		}
	},
	{#State 175
		DEFAULT => -37
	},
	{#State 176
		ACTIONS => {
			"}" => 179
		}
	},
	{#State 177
		DEFAULT => -22
	},
	{#State 178
		DEFAULT => -26
	},
	{#State 179
		DEFAULT => -82
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
#line 30 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 31 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stma', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 5
		 'stmt', 1,
sub
#line 37 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 6
		 'stmt', 2,
sub
#line 38 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 2,
sub
#line 39 "Farnsworth.yp"
{ bless [ @{$_[2]} ], 'DeclareVar' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 40 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 42 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 11
		 'stmt', 3,
sub
#line 43 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 12
		 'stmt', 1, undef
	],
	[#Rule 13
		 'stmt', 1, undef
	],
	[#Rule 14
		 'ifstartcond', 4,
sub
#line 48 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 15
		 'ifstmts', 3,
sub
#line 50 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 16
		 'if', 2,
sub
#line 53 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 17
		 'if', 4,
sub
#line 54 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 18
		 'if', 3,
sub
#line 55 "Farnsworth.yp"
{bless [@_[1,3], undef], 'If'}
	],
	[#Rule 19
		 'if', 5,
sub
#line 56 "Farnsworth.yp"
{bless [@_[1,3,5]], 'If'}
	],
	[#Rule 20
		 'if', 6,
sub
#line 57 "Farnsworth.yp"
{bless [@_[1,3,6]], 'If'}
	],
	[#Rule 21
		 'if', 6,
sub
#line 58 "Farnsworth.yp"
{bless [@_[1,3,6]], 'If'}
	],
	[#Rule 22
		 'if', 7,
sub
#line 59 "Farnsworth.yp"
{bless [@_[1,3,7]], 'If'}
	],
	[#Rule 23
		 'if', 5,
sub
#line 60 "Farnsworth.yp"
{bless [@_[1,2,5]], 'If'}
	],
	[#Rule 24
		 'if', 5,
sub
#line 61 "Farnsworth.yp"
{bless [@_[1,2,5]], 'If'}
	],
	[#Rule 25
		 'if', 6,
sub
#line 62 "Farnsworth.yp"
{bless [@_[1,2,6]], 'If'}
	],
	[#Rule 26
		 'while', 7,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 27
		 'array', 3,
sub
#line 77 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 28
		 'array', 1,
sub
#line 78 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 29
		 'array', 0,
sub
#line 79 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 30
		 'array', 2,
sub
#line 80 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 31
		 'argarray', 3,
sub
#line 83 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'ArgArray' ? @{$_[3]} : $_[3] ], 'ArgArray' }
	],
	[#Rule 32
		 'argarray', 2,
sub
#line 84 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'ArgArray' ? @{$_[2]} : $_[2] ], 'ArgArray' }
	],
	[#Rule 33
		 'argarray', 1,
sub
#line 85 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'ArgArray' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'ArgArray'}
	],
	[#Rule 34
		 'argarray', 0,
sub
#line 86 "Farnsworth.yp"
{bless [], 'ArgArray'}
	],
	[#Rule 35
		 'constraint', 1, undef
	],
	[#Rule 36
		 'constraint', 1,
sub
#line 90 "Farnsworth.yp"
{bless [], 'VarArg'}
	],
	[#Rule 37
		 'argelement', 5,
sub
#line 93 "Farnsworth.yp"
{bless [$_[1], $_[3], $_[5]], 'Argele'}
	],
	[#Rule 38
		 'argelement', 3,
sub
#line 94 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 39
		 'argelement', 3,
sub
#line 95 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 40
		 'argelement', 1,
sub
#line 96 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 41
		 'argelement', 0, undef
	],
	[#Rule 42
		 'arglist', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 43
		 'arglist', 1,
sub
#line 101 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 44
		 'exprval1', 1,
sub
#line 104 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 45
		 'exprval1', 1,
sub
#line 105 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 46
		 'exprval2', 1,
sub
#line 109 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 47
		 'exprval2', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 48
		 'exprval2', 4,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 49
		 'exprval', 1, undef
	],
	[#Rule 50
		 'exprval', 1, undef
	],
	[#Rule 51
		 'exprval', 1, undef
	],
	[#Rule 52
		 'assignexpr', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 53
		 'arrayfetchexpr', 4,
sub
#line 122 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 54
		 'expr', 1,
sub
#line 126 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 55
		 'expr', 2,
sub
#line 127 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 128 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 57
		 'expr', 3,
sub
#line 129 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 59
		 'expr', 3,
sub
#line 131 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 60
		 'expr', 2,
sub
#line 132 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 61
		 'expr', 3,
sub
#line 133 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 62
		 'expr', 3,
sub
#line 134 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 63
		 'expr', 3,
sub
#line 135 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 64
		 'expr', 3,
sub
#line 136 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 65
		 'expr', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 66
		 'expr', 3,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 67
		 'expr', 5,
sub
#line 139 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 68
		 'expr', 3,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 69
		 'expr', 3,
sub
#line 141 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 70
		 'expr', 3,
sub
#line 142 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 71
		 'expr', 2,
sub
#line 143 "Farnsworth.yp"
{ bless [ @_[2] ], 'Not' }
	],
	[#Rule 72
		 'expr', 3,
sub
#line 144 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 73
		 'expr', 3,
sub
#line 145 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 74
		 'expr', 3,
sub
#line 146 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 75
		 'expr', 3,
sub
#line 147 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 76
		 'expr', 3,
sub
#line 148 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 77
		 'expr', 3,
sub
#line 149 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 78
		 'expr', 3,
sub
#line 150 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 79
		 'expr', 3,
sub
#line 151 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 80
		 'expr', 3,
sub
#line 152 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 81
		 'expr', 6,
sub
#line 153 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 82
		 'expr', 8,
sub
#line 154 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 83
		 'expr', 3,
sub
#line 155 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 84
		 'expr', 6,
sub
#line 156 "Farnsworth.yp"
{bless [ @_[3,5] ], 'Lambda'}
	],
	[#Rule 85
		 'expr', 3,
sub
#line 157 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 86
		 'expr', 3,
sub
#line 158 "Farnsworth.yp"
{ bless [($_[1]->[0][0]), ($_[1]->[1]), $_[3]], 'ArrayStore' }
	],
	[#Rule 87
		 'expr', 3,
sub
#line 159 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 88
		 'expr', 1,
sub
#line 160 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 89
		 'expr', 1,
sub
#line 161 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 90
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 164 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G\s*/\*.*?\*/\s*|gcs and redo; #skip C comments
	$s =~ m|\G\s*//.*|gc and redo;
#	$s =~ s|\G/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /\G(0x[[:xdigit:]]+)/igc and return 'HEXNUMBER', $1;
	$s =~ /\G(0b[01]+)/igc and return 'HEXNUMBER', $1; #binary
	$s =~ /\G(0[0-7]+)/igc and return 'HEXNUMBER', $1; #octal
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
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^\^?|=|;|\n|\{|\}|\>|\<|\?|\:|\,|\&\&|\|\||\!|\||\.\.\.|\`)\s*/cg and return $1;
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
