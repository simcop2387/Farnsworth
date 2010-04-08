####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Language::Farnsworth::Parser;
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


#line 21 "Farnsworth.yp"

use Data::Dumper; 
my $s;		# warning - not re-entrant
my $fullstring;
my $charcount;
use warnings;
use diagnostics;
use Language::Farnsworth::Parser::Extra; #provides a really nasty regex for lots of fun unicode symbols
my $uni = $Language::Farnsworth::Parser::Extra::regex; #get the really annoyingly named regex
my $identifier = qr/(?:\w|$uni)(?:[\w\d]|$uni)*/;


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
			'DATE' => 3,
			'STRING' => 23,
			"if" => 24,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 28,
			"var" => 29,
			"while" => 30,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'lambda' => 22,
			'number' => 21,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 26,
			'multexpr' => 9,
			'stma' => 13,
			'value' => 14,
			'ifstartcond' => 15,
			'stmt' => 32,
			'assigncomb' => 16,
			'exprnouminus' => 31,
			'while' => 33,
			'assignexpr2' => 34,
			'logic' => 19
		}
	},
	{#State 1
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 35,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 2
		DEFAULT => -88
	},
	{#State 3
		DEFAULT => -67
	},
	{#State 4
		DEFAULT => -89
	},
	{#State 5
		DEFAULT => -44
	},
	{#State 6
		DEFAULT => -11
	},
	{#State 7
		DEFAULT => -75
	},
	{#State 8
		ACTIONS => {
			"{`" => 12,
			'NAME' => 38,
			'DATE' => 3,
			'STRING' => 23,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27
		},
		GOTOS => {
			'parens' => 7,
			'singleval' => 37,
			'number' => 21,
			'lambda' => 22,
			'value' => 14
		}
	},
	{#State 9
		DEFAULT => -77
	},
	{#State 10
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			"," => 39,
			'STRING' => 23,
			"++" => 25,
			'HEXNUMBER' => 18,
			"!" => 8,
			"(" => 17,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'array' => 40,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 41,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 11
		ACTIONS => {
			"{`" => 12,
			'NAME' => 38,
			'DATE' => 3,
			'STRING' => 23,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27
		},
		GOTOS => {
			'parens' => 7,
			'singleval' => 42,
			'number' => 21,
			'lambda' => 22,
			'value' => 14
		}
	},
	{#State 12
		ACTIONS => {
			'NAME' => 45
		},
		DEFAULT => -33,
		GOTOS => {
			'arglist' => 46,
			'argelement' => 43,
			'arglistfilled' => 44
		}
	},
	{#State 13
		ACTIONS => {
			'' => 47
		}
	},
	{#State 14
		DEFAULT => -74
	},
	{#State 15
		ACTIONS => {
			"{" => 49
		},
		GOTOS => {
			'ifstmts' => 48
		}
	},
	{#State 16
		DEFAULT => -96
	},
	{#State 17
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 50,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 18
		DEFAULT => -35
	},
	{#State 19
		DEFAULT => -87
	},
	{#State 20
		ACTIONS => {
			"\@" => 51,
			'DATE' => 3,
			"[" => 10,
			"--" => 52,
			"{`" => 12,
			'HEXNUMBER' => 18,
			"(" => 17,
			'STRING' => 23,
			"++" => 54,
			'NUMBER' => 27,
			'NAME' => 38
		},
		DEFAULT => -76,
		GOTOS => {
			'parens' => 7,
			'singleval' => 53,
			'number' => 21,
			'lambda' => 22,
			'value' => 14
		}
	},
	{#State 21
		DEFAULT => -66
	},
	{#State 22
		DEFAULT => -72
	},
	{#State 23
		DEFAULT => -68
	},
	{#State 24
		ACTIONS => {
			"(" => 55
		}
	},
	{#State 25
		ACTIONS => {
			"{`" => 12,
			'NAME' => 38,
			'DATE' => 3,
			'STRING' => 23,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27
		},
		GOTOS => {
			'parens' => 7,
			'singleval' => 56,
			'number' => 21,
			'lambda' => 22,
			'value' => 14
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"|||" => 67,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			":->" => 81,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"=" => 88,
			"+=" => 87,
			"<=>" => 89
		},
		DEFAULT => -4
	},
	{#State 27
		DEFAULT => -34
	},
	{#State 28
		ACTIONS => {
			"::-" => 90,
			":=" => 91,
			"=!=" => 93,
			"{" => 92,
			":-" => 94
		},
		DEFAULT => -70
	},
	{#State 29
		ACTIONS => {
			'NAME' => 95
		}
	},
	{#State 30
		ACTIONS => {
			"(" => 96
		}
	},
	{#State 31
		DEFAULT => -97
	},
	{#State 32
		ACTIONS => {
			";" => 97
		},
		DEFAULT => -2
	},
	{#State 33
		DEFAULT => -12
	},
	{#State 34
		DEFAULT => -45
	},
	{#State 35
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -98
	},
	{#State 36
		ACTIONS => {
			"::-" => 90,
			"{" => 92,
			":-" => 94
		},
		DEFAULT => -70
	},
	{#State 37
		ACTIONS => {
			"\@" => 51
		},
		DEFAULT => -54
	},
	{#State 38
		DEFAULT => -70
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 39,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 36,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'array' => 98,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 41,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 40
		ACTIONS => {
			"]" => 99
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"," => 100,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -19
	},
	{#State 42
		ACTIONS => {
			"\@" => 51
		},
		DEFAULT => -63
	},
	{#State 43
		ACTIONS => {
			"," => 101
		},
		DEFAULT => -31
	},
	{#State 44
		DEFAULT => -32
	},
	{#State 45
		ACTIONS => {
			"isa" => 103,
			"byref" => 102,
			"=" => 104
		},
		DEFAULT => -27
	},
	{#State 46
		ACTIONS => {
			"`" => 105
		}
	},
	{#State 47
		DEFAULT => 0
	},
	{#State 48
		ACTIONS => {
			"else" => 106
		},
		DEFAULT => -15
	},
	{#State 49
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 23,
			"if" => 24,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 28,
			"var" => 29,
			"while" => 30,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 26,
			'multexpr' => 9,
			'stma' => 107,
			'value' => 14,
			'ifstartcond' => 15,
			'stmt' => 32,
			'assigncomb' => 16,
			'exprnouminus' => 31,
			'while' => 33,
			'assignexpr2' => 34,
			'logic' => 19
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			")" => 108,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		}
	},
	{#State 51
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			"," => 39,
			'STRING' => 23,
			"++" => 25,
			'HEXNUMBER' => 18,
			"!" => 8,
			"(" => 17,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'array' => 109,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 41,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 52
		DEFAULT => -65
	},
	{#State 53
		ACTIONS => {
			"\@" => 51,
			'DATE' => 3,
			"!" => 8,
			"[" => 10,
			"--" => 11,
			"{`" => 12,
			"(" => 17,
			'HEXNUMBER' => 18,
			'STRING' => 23,
			"++" => 25,
			'NUMBER' => 27,
			'NAME' => 36
		},
		DEFAULT => -48,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 110,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 54
		DEFAULT => -64
	},
	{#State 55
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 111,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 56
		ACTIONS => {
			"\@" => 51
		},
		DEFAULT => -62
	},
	{#State 57
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 112,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 58
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 113,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 59
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 114,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 60
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 115,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 61
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 116,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 62
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 117,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 63
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 118,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 64
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 119,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 65
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 120,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 66
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 121,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 67
		ACTIONS => {
			'NAME' => 122
		}
	},
	{#State 68
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 123,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 69
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 124,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 70
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 125,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 71
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 126,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 72
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 127,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 73
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 128,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 74
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 129,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 75
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 130,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 76
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 131,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 77
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 132,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 78
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 133,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 79
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 134,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 80
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 135,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 81
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 136,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 82
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 137,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 83
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 138,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 84
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 139,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 85
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 140,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 86
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 141,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 87
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 142,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 88
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 143,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 89
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 144,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 90
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 145,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 91
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 146,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 92
		ACTIONS => {
			'NAME' => 45
		},
		DEFAULT => -33,
		GOTOS => {
			'arglist' => 147,
			'argelement' => 43,
			'arglistfilled' => 44
		}
	},
	{#State 93
		ACTIONS => {
			'NAME' => 148
		}
	},
	{#State 94
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 149,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 95
		ACTIONS => {
			"=" => 150
		},
		DEFAULT => -5
	},
	{#State 96
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 151,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 97
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 23,
			"if" => 24,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 28,
			"var" => 29,
			"while" => 30,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 26,
			'multexpr' => 9,
			'stma' => 152,
			'value' => 14,
			'ifstartcond' => 15,
			'stmt' => 32,
			'assigncomb' => 16,
			'exprnouminus' => 31,
			'while' => 33,
			'assignexpr2' => 34,
			'logic' => 19
		}
	},
	{#State 98
		DEFAULT => -21
	},
	{#State 99
		DEFAULT => -71
	},
	{#State 100
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 39,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 36,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'array' => 153,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 41,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 101
		ACTIONS => {
			'NAME' => 45
		},
		GOTOS => {
			'argelement' => 43,
			'arglistfilled' => 154
		}
	},
	{#State 102
		ACTIONS => {
			"isa" => 155
		},
		DEFAULT => -29
	},
	{#State 103
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			"..." => 158,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 157,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'constraint' => 156,
			'logic' => 19
		}
	},
	{#State 104
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 159,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 105
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 23,
			"if" => 24,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 28,
			"var" => 29,
			"while" => 30,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 26,
			'multexpr' => 9,
			'stma' => 160,
			'value' => 14,
			'ifstartcond' => 15,
			'stmt' => 32,
			'assigncomb' => 16,
			'exprnouminus' => 31,
			'while' => 33,
			'assignexpr2' => 34,
			'logic' => 19
		}
	},
	{#State 106
		ACTIONS => {
			"{" => 49
		},
		GOTOS => {
			'ifstmts' => 161
		}
	},
	{#State 107
		ACTIONS => {
			"}" => 162
		}
	},
	{#State 108
		DEFAULT => -73
	},
	{#State 109
		ACTIONS => {
			"\$" => 163
		}
	},
	{#State 110
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -49
	},
	{#State 111
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			")" => 164,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		}
	},
	{#State 112
		ACTIONS => {
			"%" => 61,
			" " => 64,
			"*" => 65,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"/" => 86
		},
		DEFAULT => -81
	},
	{#State 113
		ACTIONS => {
			"-" => 57,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -85
	},
	{#State 114
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -55
	},
	{#State 115
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -40
	},
	{#State 116
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -84
	},
	{#State 117
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -59
	},
	{#State 118
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -58
	},
	{#State 119
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -50
	},
	{#State 120
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -47
	},
	{#State 121
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -42
	},
	{#State 122
		DEFAULT => -10
	},
	{#State 123
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -52
	},
	{#State 124
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"||" => 68,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -95
	},
	{#State 125
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -38
	},
	{#State 126
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -39
	},
	{#State 127
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"||" => 68,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -94
	},
	{#State 128
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -57
	},
	{#State 129
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -56
	},
	{#State 130
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -41
	},
	{#State 131
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -43
	},
	{#State 132
		ACTIONS => {
			"%" => 61,
			" " => 64,
			"*" => 65,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"/" => 86
		},
		DEFAULT => -80
	},
	{#State 133
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -78
	},
	{#State 134
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -79
	},
	{#State 135
		ACTIONS => {
			"%" => 61,
			" " => 64,
			"*" => 65,
			"**" => 78,
			"^" => 79,
			"/" => 86
		},
		DEFAULT => -83
	},
	{#State 136
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -8
	},
	{#State 137
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -61
	},
	{#State 138
		ACTIONS => {
			":" => 165,
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		}
	},
	{#State 139
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -51
	},
	{#State 140
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -53
	},
	{#State 141
		ACTIONS => {
			"**" => 78,
			"^" => 79
		},
		DEFAULT => -82
	},
	{#State 142
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -37
	},
	{#State 143
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -36
	},
	{#State 144
		ACTIONS => {
			"-" => 57,
			"<" => undef,
			"%" => 61,
			"==" => undef,
			">=" => undef,
			" " => 64,
			"*" => 65,
			"<=" => undef,
			">" => undef,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => undef,
			"/" => 86,
			"<=>" => undef
		},
		DEFAULT => -60
	},
	{#State 145
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -90
	},
	{#State 146
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -7
	},
	{#State 147
		ACTIONS => {
			"}" => 166
		}
	},
	{#State 148
		DEFAULT => -9
	},
	{#State 149
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -91
	},
	{#State 150
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 167,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 151
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			")" => 168,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		}
	},
	{#State 152
		DEFAULT => -3
	},
	{#State 153
		DEFAULT => -18
	},
	{#State 154
		DEFAULT => -30
	},
	{#State 155
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			"..." => 158,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 157,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'constraint' => 169,
			'logic' => 19
		}
	},
	{#State 156
		DEFAULT => -25
	},
	{#State 157
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -22
	},
	{#State 158
		DEFAULT => -23
	},
	{#State 159
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"isa" => 170,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -26
	},
	{#State 160
		ACTIONS => {
			"}" => 171
		}
	},
	{#State 161
		DEFAULT => -16
	},
	{#State 162
		DEFAULT => -14
	},
	{#State 163
		DEFAULT => -69
	},
	{#State 164
		DEFAULT => -13
	},
	{#State 165
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 172,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 166
		ACTIONS => {
			":=" => 173
		}
	},
	{#State 167
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -6
	},
	{#State 168
		ACTIONS => {
			"{" => 174
		}
	},
	{#State 169
		DEFAULT => -28
	},
	{#State 170
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			"..." => 158,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 157,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'constraint' => 175,
			'logic' => 19
		}
	},
	{#State 171
		DEFAULT => -46
	},
	{#State 172
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"||" => 68,
			"<=" => 73,
			">" => 74,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"<=>" => 89
		},
		DEFAULT => -86
	},
	{#State 173
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 36,
			'DATE' => 3,
			"{" => 177,
			'STRING' => 23,
			"++" => 25,
			"!" => 8,
			"(" => 17,
			'HEXNUMBER' => 18,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'value' => 14,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 31,
			'parens' => 7,
			'assigncomb' => 16,
			'expr' => 176,
			'assignexpr2' => 34,
			'multexpr' => 9,
			'logic' => 19
		}
	},
	{#State 174
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 23,
			"if" => 24,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 28,
			"var" => 29,
			"while" => 30,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 26,
			'multexpr' => 9,
			'stma' => 178,
			'value' => 14,
			'ifstartcond' => 15,
			'stmt' => 32,
			'assigncomb' => 16,
			'exprnouminus' => 31,
			'while' => 33,
			'assignexpr2' => 34,
			'logic' => 19
		}
	},
	{#State 175
		DEFAULT => -24
	},
	{#State 176
		ACTIONS => {
			"-" => 57,
			"conforms" => 58,
			"*=" => 60,
			"<" => 59,
			"%" => 61,
			"==" => 62,
			">=" => 63,
			" " => 64,
			"*" => 65,
			"**=" => 66,
			"||" => 68,
			"->" => 69,
			"-=" => 70,
			"/=" => 71,
			"=>" => 72,
			"<=" => 73,
			"%=" => 75,
			">" => 74,
			"^=" => 76,
			"+" => 77,
			"**" => 78,
			"^" => 79,
			"per" => 80,
			"!=" => 82,
			"?" => 83,
			"&&" => 84,
			"^^" => 85,
			"/" => 86,
			"+=" => 87,
			"=" => 88,
			"<=>" => 89
		},
		DEFAULT => -92
	},
	{#State 177
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 23,
			"if" => 24,
			"++" => 25,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 27,
			"--" => 11,
			"{`" => 12,
			'NAME' => 28,
			"var" => 29,
			"while" => 30,
			"(" => 17,
			'HEXNUMBER' => 18
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 20,
			'number' => 21,
			'lambda' => 22,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 26,
			'multexpr' => 9,
			'stma' => 179,
			'value' => 14,
			'ifstartcond' => 15,
			'stmt' => 32,
			'assigncomb' => 16,
			'exprnouminus' => 31,
			'while' => 33,
			'assignexpr2' => 34,
			'logic' => 19
		}
	},
	{#State 178
		ACTIONS => {
			"}" => 180
		}
	},
	{#State 179
		ACTIONS => {
			"}" => 181
		}
	},
	{#State 180
		DEFAULT => -17
	},
	{#State 181
		DEFAULT => -93
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
#line 36 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 37 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 38 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 42 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 2,
sub
#line 43 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 6
		 'stmt', 4,
sub
#line 44 "Farnsworth.yp"
{ bless [ $_[2], $_[4] ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 45 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 46 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 47 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 48 "Farnsworth.yp"
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
#line 53 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 14
		 'ifstmts', 3,
sub
#line 55 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 15
		 'if', 2,
sub
#line 58 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 16
		 'if', 4,
sub
#line 59 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 17
		 'while', 7,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 18
		 'array', 3,
sub
#line 74 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 19
		 'array', 1,
sub
#line 75 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 20
		 'array', 0,
sub
#line 76 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 21
		 'array', 2,
sub
#line 77 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 22
		 'constraint', 1, undef
	],
	[#Rule 23
		 'constraint', 1,
sub
#line 81 "Farnsworth.yp"
{bless [], 'VarArg'}
	],
	[#Rule 24
		 'argelement', 5,
sub
#line 84 "Farnsworth.yp"
{bless [ $_[1], $_[3], $_[5], 0], 'Argele'}
	],
	[#Rule 25
		 'argelement', 3,
sub
#line 85 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3], 0], 'Argele'}
	],
	[#Rule 26
		 'argelement', 3,
sub
#line 86 "Farnsworth.yp"
{bless [ $_[1], $_[3], undef, 0], 'Argele'}
	],
	[#Rule 27
		 'argelement', 1,
sub
#line 87 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 0], 'Argele'}
	],
	[#Rule 28
		 'argelement', 4,
sub
#line 88 "Farnsworth.yp"
{bless [ $_[1], undef, $_[4], 1], 'Argele'}
	],
	[#Rule 29
		 'argelement', 2,
sub
#line 89 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 1], 'Argele'}
	],
	[#Rule 30
		 'arglistfilled', 3,
sub
#line 92 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 31
		 'arglistfilled', 1,
sub
#line 93 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 32
		 'arglist', 1, undef
	],
	[#Rule 33
		 'arglist', 0, undef
	],
	[#Rule 34
		 'number', 1,
sub
#line 100 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 35
		 'number', 1,
sub
#line 101 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 36
		 'assignexpr', 3,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 37
		 'assignexpr2', 3,
sub
#line 107 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreAdd' }
	],
	[#Rule 38
		 'assignexpr2', 3,
sub
#line 108 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreSub' }
	],
	[#Rule 39
		 'assignexpr2', 3,
sub
#line 109 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreDiv' }
	],
	[#Rule 40
		 'assignexpr2', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMul' }
	],
	[#Rule 41
		 'assignexpr2', 3,
sub
#line 111 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMod' }
	],
	[#Rule 42
		 'assignexpr2', 3,
sub
#line 112 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 43
		 'assignexpr2', 3,
sub
#line 113 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 44
		 'assigncomb', 1, undef
	],
	[#Rule 45
		 'assigncomb', 1, undef
	],
	[#Rule 46
		 'lambda', 5,
sub
#line 120 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 47
		 'multexpr', 3,
sub
#line 123 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 48
		 'multexpr', 2,
sub
#line 124 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 49
		 'multexpr', 3,
sub
#line 125 "Farnsworth.yp"
{ bless [bless([ @_[1,2], 'imp'], 'Mul'), $_[3], 'imp'], 'Mul' }
	],
	[#Rule 50
		 'multexpr', 3,
sub
#line 126 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 51
		 'logic', 3,
sub
#line 129 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 52
		 'logic', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 53
		 'logic', 3,
sub
#line 131 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 54
		 'logic', 2,
sub
#line 132 "Farnsworth.yp"
{ bless [ $_[2] ], 'Not' }
	],
	[#Rule 55
		 'compare', 3,
sub
#line 135 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 56
		 'compare', 3,
sub
#line 136 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 57
		 'compare', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 58
		 'compare', 3,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 59
		 'compare', 3,
sub
#line 139 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 60
		 'compare', 3,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 61
		 'compare', 3,
sub
#line 141 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 62
		 'crement', 2,
sub
#line 144 "Farnsworth.yp"
{ bless [ $_[2] ], 'PreInc' }
	],
	[#Rule 63
		 'crement', 2,
sub
#line 145 "Farnsworth.yp"
{ bless [ $_[2] ], 'PreDec' }
	],
	[#Rule 64
		 'crement', 2,
sub
#line 146 "Farnsworth.yp"
{ bless [ $_[1] ], 'PostInc' }
	],
	[#Rule 65
		 'crement', 2,
sub
#line 147 "Farnsworth.yp"
{ bless [ $_[1] ], 'PostDec' }
	],
	[#Rule 66
		 'value', 1, undef
	],
	[#Rule 67
		 'value', 1,
sub
#line 152 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 68
		 'value', 1,
sub
#line 153 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 69
		 'value', 4,
sub
#line 154 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 70
		 'value', 1,
sub
#line 155 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 71
		 'value', 3,
sub
#line 156 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 72
		 'value', 1, undef
	],
	[#Rule 73
		 'parens', 3,
sub
#line 160 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 74
		 'singleval', 1, undef
	],
	[#Rule 75
		 'singleval', 1, undef
	],
	[#Rule 76
		 'exprnouminus', 1, undef
	],
	[#Rule 77
		 'exprnouminus', 1, undef
	],
	[#Rule 78
		 'exprnouminus', 3,
sub
#line 169 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 79
		 'exprnouminus', 3,
sub
#line 170 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 80
		 'exprnouminus', 3,
sub
#line 171 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 81
		 'exprnouminus', 3,
sub
#line 172 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 82
		 'exprnouminus', 3,
sub
#line 173 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 83
		 'exprnouminus', 3,
sub
#line 174 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 84
		 'exprnouminus', 3,
sub
#line 175 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 85
		 'exprnouminus', 3,
sub
#line 176 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 86
		 'exprnouminus', 5,
sub
#line 177 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 87
		 'exprnouminus', 1, undef
	],
	[#Rule 88
		 'exprnouminus', 1, undef
	],
	[#Rule 89
		 'exprnouminus', 1, undef
	],
	[#Rule 90
		 'exprnouminus', 3,
sub
#line 181 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 91
		 'exprnouminus', 3,
sub
#line 182 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 92
		 'exprnouminus', 6,
sub
#line 183 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 93
		 'exprnouminus', 8,
sub
#line 184 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 94
		 'exprnouminus', 3,
sub
#line 186 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 95
		 'exprnouminus', 3,
sub
#line 188 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 96
		 'exprnouminus', 1, undef
	],
	[#Rule 97
		 'expr', 1, undef
	],
	[#Rule 98
		 'expr', 2,
sub
#line 195 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 197 "Farnsworth.yp"


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
	$s =~ /\G$ws*(:=|==|!=|<=>|>=|<=|=>|->|:->|\+\+|--|\*\*=|\*\*|\+=|-=|\*=|\/=|%=|\^=)$ws*/icg and return lc $1;
	$s =~ /\G$ws*(var\b|per\b|isa\b|byref\b|\:?\:\-|\=\!\=|\|\|\|)$ws*/icg and return lc $1;
    $s =~ /\G$ws*(\})/cg and return $1;
	$s =~ /\G$ws*(\+|\*|-|\/|\%|\^\^?|=|;|\{\s*\`|\{|\}|\>|\<|\?|\:|\,|\&\&|\|\||\!|\||\.\.\.|\`)$ws*/cg and return $1;
	$s =~ /\G$ws*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)$ws*/cg and return $1;
	$s =~ /\G($identifier)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
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
