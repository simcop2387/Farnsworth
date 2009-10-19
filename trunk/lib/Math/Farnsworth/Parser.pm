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
			'STRING' => 8,
			"if" => 11,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'stmt' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 27,
			'expr' => 13,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 1
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 30,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 2
		DEFAULT => -73
	},
	{#State 3
		ACTIONS => {
			"\@" => 33,
			'DATE' => 6,
			"[" => 15,
			"(" => 26,
			'HEXNUMBER' => 28,
			'STRING' => 8,
			'NUMBER' => 16,
			'NAME' => 34
		},
		DEFAULT => -61,
		GOTOS => {
			'parens' => 10,
			'singleval' => 32,
			'number' => 5,
			'value' => 20
		}
	},
	{#State 4
		DEFAULT => -78
	},
	{#State 5
		DEFAULT => -52
	},
	{#State 6
		DEFAULT => -53
	},
	{#State 7
		DEFAULT => -81
	},
	{#State 8
		DEFAULT => -54
	},
	{#State 9
		DEFAULT => -11
	},
	{#State 10
		DEFAULT => -60
	},
	{#State 11
		ACTIONS => {
			"(" => 35
		}
	},
	{#State 12
		ACTIONS => {
			'HEXNUMBER' => 28,
			"(" => 26,
			'NAME' => 34,
			'DATE' => 6,
			"[" => 15,
			'NUMBER' => 16,
			'STRING' => 8
		},
		GOTOS => {
			'parens' => 10,
			'singleval' => 36,
			'number' => 5,
			'value' => 20
		}
	},
	{#State 13
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			":->" => 49,
			"!=" => 50,
			"|||" => 51,
			"&&" => 54,
			"||" => 53,
			"?" => 52,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -4
	},
	{#State 14
		DEFAULT => -62
	},
	{#State 15
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"," => 63,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'array' => 64,
			'expr' => 65,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 16
		DEFAULT => -33
	},
	{#State 17
		ACTIONS => {
			'NAME' => 67
		},
		DEFAULT => -30,
		GOTOS => {
			'arglist' => 68,
			'argelement' => 66
		}
	},
	{#State 18
		ACTIONS => {
			"::-" => 72,
			":=" => 69,
			"=!=" => 71,
			"{" => 70,
			":-" => 73
		},
		DEFAULT => -56
	},
	{#State 19
		ACTIONS => {
			'' => 74
		}
	},
	{#State 20
		DEFAULT => -59
	},
	{#State 21
		ACTIONS => {
			'NAME' => 75
		}
	},
	{#State 22
		ACTIONS => {
			"{" => 76
		},
		GOTOS => {
			'ifstmts' => 77
		}
	},
	{#State 23
		ACTIONS => {
			"(" => 78
		}
	},
	{#State 24
		DEFAULT => -82
	},
	{#State 25
		ACTIONS => {
			";" => 79
		},
		DEFAULT => -2
	},
	{#State 26
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 80,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 27
		DEFAULT => -12
	},
	{#State 28
		DEFAULT => -34
	},
	{#State 29
		DEFAULT => -72
	},
	{#State 30
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -83
	},
	{#State 31
		ACTIONS => {
			"::-" => 72,
			"{" => 70,
			":-" => 73
		},
		DEFAULT => -56
	},
	{#State 32
		ACTIONS => {
			"\@" => 33,
			'DATE' => 6,
			"!" => 12,
			"[" => 15,
			"{`" => 17,
			"(" => 26,
			'HEXNUMBER' => 28,
			'STRING' => 8,
			'NUMBER' => 16,
			'NAME' => 31
		},
		DEFAULT => -38,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 81,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 33
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"," => 63,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'array' => 82,
			'expr' => 65,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 34
		DEFAULT => -56
	},
	{#State 35
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 83,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 36
		ACTIONS => {
			"\@" => 33
		},
		DEFAULT => -44
	},
	{#State 37
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 84,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 38
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 85,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 39
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 86,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 40
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 87,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 41
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 88,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 42
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 89,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 43
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 90,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 44
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 91,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 45
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 92,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 46
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 93,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 47
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 94,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 48
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 95,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 49
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 96,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 50
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 97,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 51
		ACTIONS => {
			'NAME' => 98
		}
	},
	{#State 52
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 99,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 53
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 100,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 54
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 101,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 55
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 102,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 56
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 103,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 57
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 104,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 58
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 105,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 59
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 106,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 60
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 107,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 61
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 108,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 62
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 109,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 63
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"," => 63,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'array' => 110,
			'expr' => 65,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 64
		ACTIONS => {
			"]" => 111
		}
	},
	{#State 65
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"," => 112,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"||" => 53,
			"?" => 52,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -19
	},
	{#State 66
		ACTIONS => {
			"," => 113
		},
		DEFAULT => -32
	},
	{#State 67
		ACTIONS => {
			"isa" => 116,
			"byref" => 114,
			"=" => 115
		},
		DEFAULT => -27
	},
	{#State 68
		ACTIONS => {
			"`" => 117
		}
	},
	{#State 69
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 118,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 70
		ACTIONS => {
			'NAME' => 67
		},
		DEFAULT => -30,
		GOTOS => {
			'arglist' => 119,
			'argelement' => 66
		}
	},
	{#State 71
		ACTIONS => {
			'NAME' => 120
		}
	},
	{#State 72
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 121,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 73
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 122,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 74
		DEFAULT => 0
	},
	{#State 75
		ACTIONS => {
			"=" => 123
		},
		DEFAULT => -5
	},
	{#State 76
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 8,
			"if" => 11,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'stma' => 124,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'ifstartcond' => 22,
			'if' => 9,
			'assignexpr' => 7,
			'stmt' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 27,
			'expr' => 13,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 77
		ACTIONS => {
			"else" => 125
		},
		DEFAULT => -15
	},
	{#State 78
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 126,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 1,
			'DATE' => 6,
			'STRING' => 8,
			"if" => 11,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16,
			"{`" => 17,
			'NAME' => 18,
			"var" => 21,
			"while" => 23,
			"(" => 26,
			'HEXNUMBER' => 28
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'stma' => 127,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'ifstartcond' => 22,
			'if' => 9,
			'assignexpr' => 7,
			'stmt' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 27,
			'expr' => 13,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 80
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			")" => 128,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		}
	},
	{#State 81
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -39
	},
	{#State 82
		ACTIONS => {
			"\$" => 129
		}
	},
	{#State 83
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			")" => 130,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		}
	},
	{#State 84
		ACTIONS => {
			"%" => 42,
			" " => 46,
			"*" => 47,
			"**" => 40,
			"^" => 45,
			"per" => 48,
			"/" => 57
		},
		DEFAULT => -64
	},
	{#State 85
		ACTIONS => {
			"-" => 37,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -70
	},
	{#State 86
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -45
	},
	{#State 87
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -69
	},
	{#State 88
		ACTIONS => {
			"%" => 42,
			" " => 46,
			"*" => 47,
			"**" => 40,
			"^" => 45,
			"per" => 48,
			"/" => 57
		},
		DEFAULT => -63
	},
	{#State 89
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -67
	},
	{#State 90
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -49
	},
	{#State 91
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -48
	},
	{#State 92
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -68
	},
	{#State 93
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -40
	},
	{#State 94
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -37
	},
	{#State 95
		ACTIONS => {
			"%" => 42,
			" " => 46,
			"*" => 47,
			"**" => 40,
			"^" => 45,
			"/" => 57
		},
		DEFAULT => -66
	},
	{#State 96
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -8
	},
	{#State 97
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -51
	},
	{#State 98
		DEFAULT => -10
	},
	{#State 99
		ACTIONS => {
			":" => 131,
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		}
	},
	{#State 100
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -42
	},
	{#State 101
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -41
	},
	{#State 102
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -43
	},
	{#State 103
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -80
	},
	{#State 104
		ACTIONS => {
			"**" => 40,
			"^" => 45
		},
		DEFAULT => -65
	},
	{#State 105
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"->" => 56,
			"=>" => 59,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"=" => 58,
			"<=>" => 60
		},
		DEFAULT => -35
	},
	{#State 106
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -79
	},
	{#State 107
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -50
	},
	{#State 108
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -47
	},
	{#State 109
		ACTIONS => {
			"-" => 37,
			"<" => undef,
			"%" => 42,
			"==" => undef,
			">=" => undef,
			" " => 46,
			"*" => 47,
			"<=" => undef,
			">" => undef,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => undef,
			"/" => 57,
			"<=>" => undef
		},
		DEFAULT => -46
	},
	{#State 110
		DEFAULT => -21
	},
	{#State 111
		DEFAULT => -57
	},
	{#State 112
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"," => 63,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'array' => 132,
			'expr' => 65,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 113
		ACTIONS => {
			'NAME' => 67
		},
		DEFAULT => -30,
		GOTOS => {
			'arglist' => 133,
			'argelement' => 66
		}
	},
	{#State 114
		ACTIONS => {
			"isa" => 134
		},
		DEFAULT => -29
	},
	{#State 115
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 135,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 116
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"..." => 138,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'expr' => 136,
			'multexpr' => 14,
			'constraint' => 137,
			'logic' => 29
		}
	},
	{#State 117
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 8,
			"if" => 11,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'stma' => 139,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'ifstartcond' => 22,
			'if' => 9,
			'assignexpr' => 7,
			'stmt' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 27,
			'expr' => 13,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 118
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -7
	},
	{#State 119
		ACTIONS => {
			"}" => 140
		}
	},
	{#State 120
		DEFAULT => -9
	},
	{#State 121
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"->" => 56,
			"=>" => 59,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"=" => 58,
			"<=>" => 60
		},
		DEFAULT => -74
	},
	{#State 122
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"->" => 56,
			"=>" => 59,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"=" => 58,
			"<=>" => 60
		},
		DEFAULT => -75
	},
	{#State 123
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 141,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 124
		ACTIONS => {
			"}" => 142
		}
	},
	{#State 125
		ACTIONS => {
			"{" => 76
		},
		GOTOS => {
			'ifstmts' => 143
		}
	},
	{#State 126
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			")" => 144,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		}
	},
	{#State 127
		DEFAULT => -3
	},
	{#State 128
		DEFAULT => -58
	},
	{#State 129
		DEFAULT => -55
	},
	{#State 130
		DEFAULT => -13
	},
	{#State 131
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 145,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 132
		DEFAULT => -18
	},
	{#State 133
		DEFAULT => -31
	},
	{#State 134
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"..." => 138,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'expr' => 136,
			'multexpr' => 14,
			'constraint' => 146,
			'logic' => 29
		}
	},
	{#State 135
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"isa" => 147,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -26
	},
	{#State 136
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -22
	},
	{#State 137
		DEFAULT => -25
	},
	{#State 138
		DEFAULT => -23
	},
	{#State 139
		ACTIONS => {
			"}" => 148
		}
	},
	{#State 140
		ACTIONS => {
			":=" => 149
		}
	},
	{#State 141
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"+" => 41,
			"**" => 40,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"^" => 45,
			"*" => 47,
			"per" => 48,
			"!=" => 50,
			"&&" => 54,
			"?" => 52,
			"||" => 53,
			"^^" => 55,
			"/" => 57,
			"->" => 56,
			"=" => 58,
			"=>" => 59,
			"<=" => 61,
			"<=>" => 60,
			">" => 62
		},
		DEFAULT => -6
	},
	{#State 142
		DEFAULT => -14
	},
	{#State 143
		DEFAULT => -16
	},
	{#State 144
		ACTIONS => {
			"{" => 150
		}
	},
	{#State 145
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"<=>" => 60
		},
		DEFAULT => -71
	},
	{#State 146
		DEFAULT => -28
	},
	{#State 147
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"..." => 138,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'exprnouminus' => 24,
			'parens' => 10,
			'expr' => 136,
			'multexpr' => 14,
			'constraint' => 151,
			'logic' => 29
		}
	},
	{#State 148
		DEFAULT => -36
	},
	{#State 149
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 31,
			'DATE' => 6,
			"{" => 153,
			'STRING' => 8,
			'HEXNUMBER' => 28,
			"(" => 26,
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
			'assignexpr' => 7,
			'parens' => 10,
			'exprnouminus' => 24,
			'expr' => 152,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 150
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 8,
			"if" => 11,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'stma' => 154,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'ifstartcond' => 22,
			'if' => 9,
			'assignexpr' => 7,
			'stmt' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 27,
			'expr' => 13,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 151
		DEFAULT => -24
	},
	{#State 152
		ACTIONS => {
			"-" => 37,
			"conforms" => 38,
			"<" => 39,
			"%" => 42,
			"==" => 43,
			">=" => 44,
			" " => 46,
			"*" => 47,
			"||" => 53,
			"->" => 56,
			"=>" => 59,
			"<=" => 61,
			">" => 62,
			"**" => 40,
			"+" => 41,
			"^" => 45,
			"per" => 48,
			"!=" => 50,
			"?" => 52,
			"&&" => 54,
			"^^" => 55,
			"/" => 57,
			"=" => 58,
			"<=>" => 60
		},
		DEFAULT => -76
	},
	{#State 153
		ACTIONS => {
			"{`" => 17,
			"-" => 1,
			'NAME' => 18,
			"var" => 21,
			'DATE' => 6,
			"while" => 23,
			'STRING' => 8,
			"if" => 11,
			'HEXNUMBER' => 28,
			"(" => 26,
			"!" => 12,
			"[" => 15,
			'NUMBER' => 16
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 3,
			'stma' => 155,
			'number' => 5,
			'lambda' => 4,
			'value' => 20,
			'ifstartcond' => 22,
			'if' => 9,
			'assignexpr' => 7,
			'stmt' => 25,
			'exprnouminus' => 24,
			'parens' => 10,
			'while' => 27,
			'expr' => 13,
			'multexpr' => 14,
			'logic' => 29
		}
	},
	{#State 154
		ACTIONS => {
			"}" => 156
		}
	},
	{#State 155
		ACTIONS => {
			"}" => 157
		}
	},
	{#State 156
		DEFAULT => -17
	},
	{#State 157
		DEFAULT => -77
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
		 'lambda', 5,
sub
#line 100 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 37
		 'multexpr', 3,
sub
#line 103 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 38
		 'multexpr', 2,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 39
		 'multexpr', 3,
sub
#line 105 "Farnsworth.yp"
{ bless [bless([ @_[1,2], 'imp'], 'Mul'), $_[3], 'imp'], 'Mul' }
	],
	[#Rule 40
		 'multexpr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 41
		 'logic', 3,
sub
#line 109 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 42
		 'logic', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 43
		 'logic', 3,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 44
		 'logic', 2,
sub
#line 112 "Farnsworth.yp"
{ bless [ $_[2] ], 'Not' }
	],
	[#Rule 45
		 'compare', 3,
sub
#line 115 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 46
		 'compare', 3,
sub
#line 116 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 47
		 'compare', 3,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 48
		 'compare', 3,
sub
#line 118 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 49
		 'compare', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 50
		 'compare', 3,
sub
#line 120 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 51
		 'compare', 3,
sub
#line 121 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 52
		 'value', 1, undef
	],
	[#Rule 53
		 'value', 1,
sub
#line 125 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 54
		 'value', 1,
sub
#line 126 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 55
		 'value', 4,
sub
#line 127 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 56
		 'value', 1,
sub
#line 128 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 57
		 'value', 3,
sub
#line 129 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 58
		 'parens', 3,
sub
#line 132 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 59
		 'singleval', 1, undef
	],
	[#Rule 60
		 'singleval', 1, undef
	],
	[#Rule 61
		 'exprnouminus', 1,
sub
#line 140 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 62
		 'exprnouminus', 1, undef
	],
	[#Rule 63
		 'exprnouminus', 3,
sub
#line 142 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 64
		 'exprnouminus', 3,
sub
#line 143 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 65
		 'exprnouminus', 3,
sub
#line 144 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 66
		 'exprnouminus', 3,
sub
#line 145 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 67
		 'exprnouminus', 3,
sub
#line 146 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 68
		 'exprnouminus', 3,
sub
#line 147 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 69
		 'exprnouminus', 3,
sub
#line 148 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 70
		 'exprnouminus', 3,
sub
#line 149 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 71
		 'exprnouminus', 5,
sub
#line 150 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 72
		 'exprnouminus', 1, undef
	],
	[#Rule 73
		 'exprnouminus', 1, undef
	],
	[#Rule 74
		 'exprnouminus', 3,
sub
#line 153 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 75
		 'exprnouminus', 3,
sub
#line 154 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 76
		 'exprnouminus', 6,
sub
#line 155 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 77
		 'exprnouminus', 8,
sub
#line 156 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 78
		 'exprnouminus', 1, undef
	],
	[#Rule 79
		 'exprnouminus', 3,
sub
#line 158 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 80
		 'exprnouminus', 3,
sub
#line 160 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 81
		 'exprnouminus', 1, undef
	],
	[#Rule 82
		 'expr', 1, undef
	],
	[#Rule 83
		 'expr', 2,
sub
#line 167 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 169 "Farnsworth.yp"


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
	$s =~ /\G$ws*(:=|==|!=|<=>|>=|<=|=>|->|:->|\*\*)$ws*/icg and return lc $1;
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
