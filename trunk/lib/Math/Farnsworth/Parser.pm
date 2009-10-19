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


#line 20 "Farnsworth.yp"

use Data::Dumper; #boobs
my $s;		# warning - not re-entrant
my $fullstring;
my $charcount;
use warnings;
use diagnostics;


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 7,
			"if" => 11,
			'HEXNUMBER' => 29,
			"(" => 27,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'stma' => 19,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'ifstartcond' => 22,
			'if' => 9,
			'assignexpr' => 8,
			'stmt' => 26,
			'assigncomb' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 28,
			'expr' => 13,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 1
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			'HEXNUMBER' => 29,
			"(" => 27,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'assigncomb' => 25,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 32,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 2
		DEFAULT => -82
	},
	{#State 3
		ACTIONS => {
			"\@" => 35,
			'DATE' => 6,
			"[" => 15,
			"(" => 27,
			'HEXNUMBER' => 29,
			'STRING' => 7,
			'NUMBER' => 16,
			'NAME' => 36
		},
		DEFAULT => -70,
		GOTOS => {
			'parens' => 10,
			'singleval' => 34,
			'number' => 5,
			'value' => 20
		}
	},
	{#State 4
		DEFAULT => -87
	},
	{#State 5
		DEFAULT => -61
	},
	{#State 6
		DEFAULT => -62
	},
	{#State 7
		DEFAULT => -63
	},
	{#State 8
		DEFAULT => -43
	},
	{#State 9
		DEFAULT => -11
	},
	{#State 10
		DEFAULT => -69
	},
	{#State 11
		ACTIONS => {
			"(" => 37
		}
	},
	{#State 12
		ACTIONS => {
			'HEXNUMBER' => 29,
			"(" => 27,
			'NAME' => 36,
			'DATE' => 6,
			"[" => 15,
			'NUMBER' => 16,
			'STRING' => 7
		},
		GOTOS => {
			'parens' => 10,
			'singleval' => 38,
			'number' => 5,
			'value' => 20
		}
	},
	{#State 13
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"|||" => 49,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"**" => 59,
			"+" => 60,
			"^" => 61,
			"per" => 62,
			":->" => 63,
			"!=" => 64,
			"&&" => 65,
			"?" => 66,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -4
	},
	{#State 14
		DEFAULT => -72
	},
	{#State 15
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"," => 72,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'array' => 73,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 74,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 16
		DEFAULT => -33
	},
	{#State 17
		ACTIONS => {
			'NAME' => 76
		},
		DEFAULT => -30,
		GOTOS => {
			'arglist' => 77,
			'argelement' => 75
		}
	},
	{#State 18
		ACTIONS => {
			"::-" => 78,
			":=" => 79,
			"=!=" => 81,
			"{" => 80,
			":-" => 82
		},
		DEFAULT => -65
	},
	{#State 19
		ACTIONS => {
			'' => 83
		}
	},
	{#State 20
		DEFAULT => -68
	},
	{#State 21
		ACTIONS => {
			'NAME' => 84
		}
	},
	{#State 22
		ACTIONS => {
			"{" => 86
		},
		GOTOS => {
			'ifstmts' => 85
		}
	},
	{#State 23
		ACTIONS => {
			"(" => 87
		}
	},
	{#State 24
		DEFAULT => -91
	},
	{#State 25
		DEFAULT => -90
	},
	{#State 26
		ACTIONS => {
			";" => 88
		},
		DEFAULT => -2
	},
	{#State 27
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 89,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 28
		DEFAULT => -12
	},
	{#State 29
		DEFAULT => -34
	},
	{#State 30
		DEFAULT => -44
	},
	{#State 31
		DEFAULT => -81
	},
	{#State 32
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -92
	},
	{#State 33
		ACTIONS => {
			"::-" => 78,
			"{" => 80,
			":-" => 82
		},
		DEFAULT => -65
	},
	{#State 34
		ACTIONS => {
			"\@" => 35,
			'DATE' => 6,
			"!" => 12,
			"[" => 15,
			"{`" => 17,
			"(" => 27,
			'HEXNUMBER' => 29,
			'STRING' => 7,
			'NUMBER' => 16,
			'NAME' => 33
		},
		DEFAULT => -47,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 90,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 35
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"," => 72,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'array' => 91,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 74,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 36
		DEFAULT => -65
	},
	{#State 37
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 92,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 38
		ACTIONS => {
			"\@" => 35
		},
		DEFAULT => -53
	},
	{#State 39
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 93,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 40
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 94,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 41
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 95,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 42
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 96,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 43
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 97,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 44
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 98,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 45
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 99,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 46
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 100,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 47
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 101,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 48
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 102,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 49
		ACTIONS => {
			'NAME' => 103
		}
	},
	{#State 50
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 104,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 51
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 105,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 52
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 106,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 53
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 107,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 54
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 108,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 55
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 109,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 56
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 110,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 57
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 111,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 58
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 112,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 59
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 113,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 60
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 114,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 61
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 115,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 62
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 116,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 63
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 117,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 64
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 118,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 65
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 119,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 66
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 120,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 67
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 121,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 68
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 122,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 69
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 123,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 70
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 124,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 71
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 125,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 72
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"," => 72,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'array' => 126,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 74,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 73
		ACTIONS => {
			"]" => 127
		}
	},
	{#State 74
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"," => 128,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -19
	},
	{#State 75
		ACTIONS => {
			"," => 129
		},
		DEFAULT => -32
	},
	{#State 76
		ACTIONS => {
			"isa" => 131,
			"byref" => 130,
			"=" => 132
		},
		DEFAULT => -27
	},
	{#State 77
		ACTIONS => {
			"`" => 133
		}
	},
	{#State 78
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 134,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 79
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 135,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 80
		ACTIONS => {
			'NAME' => 76
		},
		DEFAULT => -30,
		GOTOS => {
			'arglist' => 136,
			'argelement' => 75
		}
	},
	{#State 81
		ACTIONS => {
			'NAME' => 137
		}
	},
	{#State 82
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 138,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 83
		DEFAULT => 0
	},
	{#State 84
		ACTIONS => {
			"=" => 139
		},
		DEFAULT => -5
	},
	{#State 85
		ACTIONS => {
			"else" => 140
		},
		DEFAULT => -15
	},
	{#State 86
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 7,
			"if" => 11,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'if' => 9,
			'assignexpr' => 8,
			'parens' => 10,
			'expr' => 13,
			'multexpr' => 14,
			'stma' => 141,
			'value' => 20,
			'ifstartcond' => 22,
			'assigncomb' => 25,
			'exprnouminus' => 24,
			'stmt' => 26,
			'while' => 28,
			'assignexpr2' => 30,
			'logic' => 31
		}
	},
	{#State 87
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 142,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 88
		ACTIONS => {
			"-" => 1,
			'DATE' => 6,
			'STRING' => 7,
			"if" => 11,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16,
			"{`" => 17,
			'NAME' => 18,
			"var" => 21,
			"while" => 23,
			'HEXNUMBER' => 29,
			"(" => 27
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'if' => 9,
			'assignexpr' => 8,
			'parens' => 10,
			'expr' => 13,
			'multexpr' => 14,
			'stma' => 143,
			'value' => 20,
			'ifstartcond' => 22,
			'assigncomb' => 25,
			'exprnouminus' => 24,
			'stmt' => 26,
			'while' => 28,
			'assignexpr2' => 30,
			'logic' => 31
		}
	},
	{#State 89
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			")" => 144,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		}
	},
	{#State 90
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -48
	},
	{#State 91
		ACTIONS => {
			"\$" => 145
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			")" => 146,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		}
	},
	{#State 93
		ACTIONS => {
			"%" => 43,
			" " => 46,
			"*" => 47,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"/" => 68
		},
		DEFAULT => -74
	},
	{#State 94
		ACTIONS => {
			"-" => 39,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -79
	},
	{#State 95
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -54
	},
	{#State 96
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -39
	},
	{#State 97
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -77
	},
	{#State 98
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -58
	},
	{#State 99
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -57
	},
	{#State 100
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -49
	},
	{#State 101
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -46
	},
	{#State 102
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -41
	},
	{#State 103
		DEFAULT => -10
	},
	{#State 104
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -51
	},
	{#State 105
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"||" => 50,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -89
	},
	{#State 106
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -37
	},
	{#State 107
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -38
	},
	{#State 108
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"||" => 50,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -88
	},
	{#State 109
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -56
	},
	{#State 110
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -55
	},
	{#State 111
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -40
	},
	{#State 112
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -42
	},
	{#State 113
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -71
	},
	{#State 114
		ACTIONS => {
			"%" => 43,
			" " => 46,
			"*" => 47,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"/" => 68
		},
		DEFAULT => -73
	},
	{#State 115
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -78
	},
	{#State 116
		ACTIONS => {
			"%" => 43,
			" " => 46,
			"*" => 47,
			"**" => 59,
			"^" => 61,
			"/" => 68
		},
		DEFAULT => -76
	},
	{#State 117
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -8
	},
	{#State 118
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -60
	},
	{#State 119
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -50
	},
	{#State 120
		ACTIONS => {
			":" => 147,
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		}
	},
	{#State 121
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -52
	},
	{#State 122
		ACTIONS => {
			"**" => 59,
			"^" => 61
		},
		DEFAULT => -75
	},
	{#State 123
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -35
	},
	{#State 124
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -36
	},
	{#State 125
		ACTIONS => {
			"-" => 39,
			"<" => undef,
			"%" => 43,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => undef,
			"/" => 68,
			"<=>" => undef
		},
		DEFAULT => -59
	},
	{#State 126
		DEFAULT => -21
	},
	{#State 127
		DEFAULT => -66
	},
	{#State 128
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"," => 72,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'array' => 148,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 74,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 129
		ACTIONS => {
			'NAME' => 76
		},
		DEFAULT => -30,
		GOTOS => {
			'arglist' => 149,
			'argelement' => 75
		}
	},
	{#State 130
		ACTIONS => {
			"isa" => 150
		},
		DEFAULT => -29
	},
	{#State 131
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"..." => 153,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 152,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'constraint' => 151,
			'logic' => 31
		}
	},
	{#State 132
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 154,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 133
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 7,
			"if" => 11,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'if' => 9,
			'assignexpr' => 8,
			'parens' => 10,
			'expr' => 13,
			'multexpr' => 14,
			'stma' => 155,
			'value' => 20,
			'ifstartcond' => 22,
			'assigncomb' => 25,
			'exprnouminus' => 24,
			'stmt' => 26,
			'while' => 28,
			'assignexpr2' => 30,
			'logic' => 31
		}
	},
	{#State 134
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -83
	},
	{#State 135
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -7
	},
	{#State 136
		ACTIONS => {
			"}" => 156
		}
	},
	{#State 137
		DEFAULT => -9
	},
	{#State 138
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -84
	},
	{#State 139
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 157,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 140
		ACTIONS => {
			"{" => 86
		},
		GOTOS => {
			'ifstmts' => 158
		}
	},
	{#State 141
		ACTIONS => {
			"}" => 159
		}
	},
	{#State 142
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			")" => 160,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		}
	},
	{#State 143
		DEFAULT => -3
	},
	{#State 144
		DEFAULT => -67
	},
	{#State 145
		DEFAULT => -64
	},
	{#State 146
		DEFAULT => -13
	},
	{#State 147
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 161,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 148
		DEFAULT => -18
	},
	{#State 149
		DEFAULT => -31
	},
	{#State 150
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"..." => 153,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 152,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'constraint' => 162,
			'logic' => 31
		}
	},
	{#State 151
		DEFAULT => -25
	},
	{#State 152
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -22
	},
	{#State 153
		DEFAULT => -23
	},
	{#State 154
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"isa" => 163,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -26
	},
	{#State 155
		ACTIONS => {
			"}" => 164
		}
	},
	{#State 156
		ACTIONS => {
			":=" => 165
		}
	},
	{#State 157
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -6
	},
	{#State 158
		DEFAULT => -16
	},
	{#State 159
		DEFAULT => -14
	},
	{#State 160
		ACTIONS => {
			"{" => 166
		}
	},
	{#State 161
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"||" => 50,
			"<=" => 55,
			">" => 56,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"<=>" => 71
		},
		DEFAULT => -80
	},
	{#State 162
		DEFAULT => -28
	},
	{#State 163
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"..." => 153,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 152,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'constraint' => 167,
			'logic' => 31
		}
	},
	{#State 164
		DEFAULT => -45
	},
	{#State 165
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 33,
			'DATE' => 6,
			"{" => 169,
			'STRING' => 7,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 8,
			'exprnouminus' => 24,
			'parens' => 10,
			'assigncomb' => 25,
			'expr' => 168,
			'assignexpr2' => 30,
			'multexpr' => 14,
			'logic' => 31
		}
	},
	{#State 166
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 7,
			"if" => 11,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'if' => 9,
			'assignexpr' => 8,
			'parens' => 10,
			'expr' => 13,
			'multexpr' => 14,
			'stma' => 170,
			'value' => 20,
			'ifstartcond' => 22,
			'assigncomb' => 25,
			'exprnouminus' => 24,
			'stmt' => 26,
			'while' => 28,
			'assignexpr2' => 30,
			'logic' => 31
		}
	},
	{#State 167
		DEFAULT => -24
	},
	{#State 168
		ACTIONS => {
			"-" => 39,
			"conforms" => 40,
			"*=" => 42,
			"<" => 41,
			"%" => 43,
			"==" => 44,
			">=" => 45,
			" " => 46,
			"*" => 47,
			"**=" => 48,
			"||" => 50,
			"->" => 51,
			"-=" => 52,
			"/=" => 53,
			"=>" => 54,
			"<=" => 55,
			"%=" => 57,
			">" => 56,
			"^=" => 58,
			"+" => 60,
			"**" => 59,
			"^" => 61,
			"per" => 62,
			"!=" => 64,
			"?" => 66,
			"&&" => 65,
			"^^" => 67,
			"/" => 68,
			"+=" => 70,
			"=" => 69,
			"<=>" => 71
		},
		DEFAULT => -85
	},
	{#State 169
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 7,
			"if" => 11,
			"!" => 12,
			"(" => 27,
			'HEXNUMBER' => 29,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'if' => 9,
			'assignexpr' => 8,
			'parens' => 10,
			'expr' => 13,
			'multexpr' => 14,
			'stma' => 171,
			'value' => 20,
			'ifstartcond' => 22,
			'assigncomb' => 25,
			'exprnouminus' => 24,
			'stmt' => 26,
			'while' => 28,
			'assignexpr2' => 30,
			'logic' => 31
		}
	},
	{#State 170
		ACTIONS => {
			"}" => 172
		}
	},
	{#State 171
		ACTIONS => {
			"}" => 173
		}
	},
	{#State 172
		DEFAULT => -17
	},
	{#State 173
		DEFAULT => -86
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
#line 32 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 33 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 34 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 38 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 2,
sub
#line 39 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 6
		 'stmt', 4,
sub
#line 40 "Farnsworth.yp"
{ bless [ $_[2], $_[4] ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 42 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 43 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 44 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineCombo' }
	],
	[#Rule 11
		 'stmt', 1, undef
	],
	[#Rule 12
		 'stmt', 1, undef
	],
	[#Rule 13
		 'ifstartcond', 4,
sub
#line 49 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 14
		 'ifstmts', 3,
sub
#line 51 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 15
		 'if', 2,
sub
#line 54 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 16
		 'if', 4,
sub
#line 55 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 17
		 'while', 7,
sub
#line 63 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 18
		 'array', 3,
sub
#line 70 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 19
		 'array', 1,
sub
#line 71 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 20
		 'array', 0,
sub
#line 72 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 21
		 'array', 2,
sub
#line 73 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 22
		 'constraint', 1, undef
	],
	[#Rule 23
		 'constraint', 1,
sub
#line 77 "Farnsworth.yp"
{bless [], 'VarArg'}
	],
	[#Rule 24
		 'argelement', 5,
sub
#line 80 "Farnsworth.yp"
{bless [ $_[1], $_[3], $_[5], 0], 'Argele'}
	],
	[#Rule 25
		 'argelement', 3,
sub
#line 81 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3], 0], 'Argele'}
	],
	[#Rule 26
		 'argelement', 3,
sub
#line 82 "Farnsworth.yp"
{bless [ $_[1], $_[3], undef, 0], 'Argele'}
	],
	[#Rule 27
		 'argelement', 1,
sub
#line 83 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 0], 'Argele'}
	],
	[#Rule 28
		 'argelement', 4,
sub
#line 84 "Farnsworth.yp"
{bless [ $_[1], undef, $_[4], 1], 'Argele'}
	],
	[#Rule 29
		 'argelement', 2,
sub
#line 85 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 1], 'Argele'}
	],
	[#Rule 30
		 'argelement', 0, undef
	],
	[#Rule 31
		 'arglist', 3,
sub
#line 89 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 32
		 'arglist', 1,
sub
#line 90 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 33
		 'number', 1,
sub
#line 93 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 34
		 'number', 1,
sub
#line 94 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 35
		 'assignexpr', 3,
sub
#line 97 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 36
		 'assignexpr2', 3,
sub
#line 100 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreAdd' }
	],
	[#Rule 37
		 'assignexpr2', 3,
sub
#line 101 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreSub' }
	],
	[#Rule 38
		 'assignexpr2', 3,
sub
#line 102 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreDiv' }
	],
	[#Rule 39
		 'assignexpr2', 3,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMul' }
	],
	[#Rule 40
		 'assignexpr2', 3,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMod' }
	],
	[#Rule 41
		 'assignexpr2', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 42
		 'assignexpr2', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 43
		 'assigncomb', 1, undef
	],
	[#Rule 44
		 'assigncomb', 1, undef
	],
	[#Rule 45
		 'lambda', 5,
sub
#line 113 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 46
		 'multexpr', 3,
sub
#line 116 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 47
		 'multexpr', 2,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 48
		 'multexpr', 3,
sub
#line 118 "Farnsworth.yp"
{ bless [bless([ @_[1,2], 'imp'], 'Mul'), $_[3], 'imp'], 'Mul' }
	],
	[#Rule 49
		 'multexpr', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 50
		 'logic', 3,
sub
#line 122 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 51
		 'logic', 3,
sub
#line 123 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 52
		 'logic', 3,
sub
#line 124 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 53
		 'logic', 2,
sub
#line 125 "Farnsworth.yp"
{ bless [ $_[2] ], 'Not' }
	],
	[#Rule 54
		 'compare', 3,
sub
#line 128 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 55
		 'compare', 3,
sub
#line 129 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 56
		 'compare', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 57
		 'compare', 3,
sub
#line 131 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 58
		 'compare', 3,
sub
#line 132 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 59
		 'compare', 3,
sub
#line 133 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 60
		 'compare', 3,
sub
#line 134 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 61
		 'value', 1, undef
	],
	[#Rule 62
		 'value', 1,
sub
#line 138 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 63
		 'value', 1,
sub
#line 139 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 64
		 'value', 4,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 65
		 'value', 1,
sub
#line 141 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 66
		 'value', 3,
sub
#line 142 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 67
		 'parens', 3,
sub
#line 145 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 68
		 'singleval', 1, undef
	],
	[#Rule 69
		 'singleval', 1, undef
	],
	[#Rule 70
		 'exprnouminus', 1,
sub
#line 152 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 71
		 'exprnouminus', 3,
sub
#line 153 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 72
		 'exprnouminus', 1, undef
	],
	[#Rule 73
		 'exprnouminus', 3,
sub
#line 155 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 74
		 'exprnouminus', 3,
sub
#line 156 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 75
		 'exprnouminus', 3,
sub
#line 157 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 76
		 'exprnouminus', 3,
sub
#line 158 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 77
		 'exprnouminus', 3,
sub
#line 159 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 78
		 'exprnouminus', 3,
sub
#line 160 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 79
		 'exprnouminus', 3,
sub
#line 161 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 80
		 'exprnouminus', 5,
sub
#line 162 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 81
		 'exprnouminus', 1, undef
	],
	[#Rule 82
		 'exprnouminus', 1, undef
	],
	[#Rule 83
		 'exprnouminus', 3,
sub
#line 165 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 84
		 'exprnouminus', 3,
sub
#line 166 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 85
		 'exprnouminus', 6,
sub
#line 167 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 86
		 'exprnouminus', 8,
sub
#line 168 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 87
		 'exprnouminus', 1, undef
	],
	[#Rule 88
		 'exprnouminus', 3,
sub
#line 170 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 89
		 'exprnouminus', 3,
sub
#line 172 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 90
		 'exprnouminus', 1, undef
	],
	[#Rule 91
		 'expr', 1, undef
	],
	[#Rule 92
		 'expr', 2,
sub
#line 179 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 181 "Farnsworth.yp"


#helpers!
my $ws = qr/[^\S\n]/; #whitespace without the \n

sub yylex
	{
	no warnings 'exiting'; #needed because perl doesn't seem to like me using redo there now;
	my $line = $_[-2];
	my $charline = $_[-1];
	my $lastcharline = $_[-3];
	
	#remove \n or whatever from the string
	if ($s =~ /\G$ws*\n$ws*/gc)
	{
		$$line++;
		$$lastcharline = $$charline;
		$$charline = pos $s;
		#print "LEX: ${$line} ${$charline} || ".substr($s, $$charline, index($s, "\n", $$charline)-$$charline)."\n";
		redo
	}
	
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G\s*/\*.*?\*/\s*|gcs and redo; #skip C comments
	$s =~ m|\G\s*//.*(?=\n)?|gc and redo;

    #i want a complete number regex
	$s =~ /\G(0[xb]?[[:xdigit:]](?:[[:xdigit:].]+))/igc and return 'HEXNUMBER', $1;
	#$s =~ /\G(0b[01]+)/igc and return 'HEXNUMBER', $1; #binary
	#$s =~ /\G(0[0-7]+)/igc and return 'HEXNUMBER', $1; #octal
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;
    #$s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1; #this never happens?!?

    #token out the date
    $s =~ /\G\s*#([^#]*)#\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*"((\\.|[^"\\])*)"/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(while|conforms|else|if)\b\s*/cg and return $1;

	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /\G$ws*(:=|==|!=|<=>|>=|<=|=>|->|:->|\*\*=|\*\*|\+=|-=|\*=|\/=|%=|\^=)$ws*/icg and return lc $1;
	$s =~ /\G$ws*(var\b|per\b|isa\b|byref\b|\:?\:\-|\=\!\=|\|\|\|)$ws*/icg and return lc $1;
    $s =~ /\G$ws*(\})/cg and return $1;
	$s =~ /\G$ws*(\+|\*|-|\/|\%|\^\^?|=|;|\{\s*\`|\{|\}|\>|\<|\?|\:|\,|\&\&|\|\||\!|\||\.\.\.|\`)$ws*/cg and return $1;
	$s =~ /\G$ws*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)$ws*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yylexwatch
{
   my @r = &yylex;

   my $charlines = $_[-1];
   my $line = $_[-2];
   my $pos = pos $s;

   #print Dumper(\@_);
   #print "LEX: ${$line} ${$charlines} $pos :: ".substr($s, $$charlines, $pos - $$charlines)."\n";
   #$charcount+=pos $s;
   #$s = substr($s, pos $s);
   return @r;
}

sub yyerror
	{
	my $pos = pos $s;
	my $charlines = $_[-1];
	my $lines = $_[-2];
    my $lastcharline = $_[-3];
	my $char = $pos-$charlines;

	substr($fullstring,$pos,0) = '<###YYLEX###>';
	my $fewlines = substr($fullstring, $lastcharline, index($fullstring, "\n", index($fullstring, "\n", $pos)+1) - $lastcharline);
	$fewlines =~ s/^/### /mg;
	die "### Syntax Error \@ $lines : $char ($charlines $pos) of $fewlines\n";
	}

sub parse
	{
	$charcount=0;
	my $line = 1;
	my $charlines = 0;
	my $lastcharlines = 0;
	my $self = shift;
	$s = join ' ', @_;
	$fullstring = $s; #preserve it for errors
	my $code = eval
		{ $self->new(yylex => sub {yylexwatch(@_, \$lastcharlines, \$line, \$charlines)}, yyerror => sub {yyerror(@_, $lastcharlines, $line, $charlines)})->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
