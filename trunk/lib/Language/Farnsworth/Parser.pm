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


#line 20 "Farnsworth.yp"

use Data::Dumper; 
my $s;		# warning - not re-entrant
my $fullstring;
my $charcount;
use warnings;
use Language::Farnsworth::Parser::Extra; #provides a really nasty regex for lots of fun unicode symbols
my $uni = $Language::Farnsworth::Parser::Extra::regex; #get the really annoyingly named regex
my $identifier = qr/(?:\w|$uni)(?:[\w\d]|$uni|::)*/;


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
			'STRING' => 25,
			"if" => 26,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 32,
			"{|" => 14,
			"var" => 34,
			"&" => 36,
			"while" => 37,
			"module" => 17,
			"defun" => 40,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'lambda' => 24,
			'number' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 28,
			'arrayindex' => 29,
			'multexpr' => 9,
			'module' => 31,
			'powexp' => 33,
			'stma' => 13,
			'value' => 15,
			'standardmath' => 35,
			'ifstartcond' => 16,
			'stmt' => 39,
			'exprnouminus' => 38,
			'assigncomb' => 18,
			'singlevalnoindex' => 42,
			'while' => 41,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 1
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 44,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 2
		DEFAULT => -100
	},
	{#State 3
		DEFAULT => -43
	},
	{#State 4
		DEFAULT => -101
	},
	{#State 5
		DEFAULT => -62
	},
	{#State 6
		DEFAULT => -12
	},
	{#State 7
		DEFAULT => -51
	},
	{#State 8
		ACTIONS => {
			"{`" => 12,
			'NAME' => 47,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"(" => 19,
			'HEXNUMBER' => 20,
			"[" => 10,
			'NUMBER' => 30
		},
		GOTOS => {
			'parens' => 7,
			'singlevalnoindex' => 42,
			'singleval' => 46,
			'number' => 23,
			'lambda' => 24,
			'value' => 15,
			'arrayindex' => 29
		}
	},
	{#State 9
		DEFAULT => -93
	},
	{#State 10
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 48,
			'STRING' => 25,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 45,
			"{|" => 14,
			"&" => 36,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -25,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 49,
			'parens' => 7,
			'expr' => 50,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 11
		ACTIONS => {
			"{`" => 12,
			'NAME' => 47,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"(" => 19,
			'HEXNUMBER' => 20,
			"[" => 10,
			'NUMBER' => 30
		},
		GOTOS => {
			'parens' => 7,
			'singlevalnoindex' => 42,
			'singleval' => 51,
			'number' => 23,
			'lambda' => 24,
			'value' => 15,
			'arrayindex' => 29
		}
	},
	{#State 12
		ACTIONS => {
			'NAME' => 54
		},
		DEFAULT => -38,
		GOTOS => {
			'arglist' => 55,
			'argelement' => 52,
			'arglistfilled' => 53
		}
	},
	{#State 13
		ACTIONS => {
			'' => 56
		}
	},
	{#State 14
		ACTIONS => {
			'NAME' => 54
		},
		DEFAULT => -38,
		GOTOS => {
			'arglist' => 57,
			'argelement' => 52,
			'arglistfilled' => 53
		}
	},
	{#State 15
		DEFAULT => -50
	},
	{#State 16
		ACTIONS => {
			"{" => 58
		},
		GOTOS => {
			'block' => 59
		}
	},
	{#State 17
		ACTIONS => {
			'NAME' => 60
		}
	},
	{#State 18
		DEFAULT => -105
	},
	{#State 19
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 61,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 20
		DEFAULT => -40
	},
	{#State 21
		DEFAULT => -99
	},
	{#State 22
		ACTIONS => {
			"\@" => 62,
			'DATE' => 3,
			"!" => 63,
			"[" => 10,
			"--" => 64,
			"{`" => 12,
			"{|" => 14,
			"(" => 19,
			'HEXNUMBER' => 20,
			'STRING' => 25,
			"++" => 66,
			'NUMBER' => 30,
			'NAME' => 47,
			"&" => 36
		},
		DEFAULT => -92,
		GOTOS => {
			'parens' => 7,
			'singlevalnoindex' => 42,
			'singleval' => 65,
			'number' => 23,
			'lambda' => 24,
			'value' => 15,
			'arrayindex' => 29
		}
	},
	{#State 23
		DEFAULT => -42
	},
	{#State 24
		DEFAULT => -47
	},
	{#State 25
		DEFAULT => -44
	},
	{#State 26
		ACTIONS => {
			"(" => 67
		}
	},
	{#State 27
		ACTIONS => {
			"{`" => 12,
			'NAME' => 47,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"(" => 19,
			'HEXNUMBER' => 20,
			"[" => 10,
			'NUMBER' => 30
		},
		GOTOS => {
			'parens' => 7,
			'singlevalnoindex' => 42,
			'singleval' => 68,
			'number' => 23,
			'lambda' => 24,
			'value' => 15,
			'arrayindex' => 29
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"|||" => 79,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			":->" => 92,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -4
	},
	{#State 29
		DEFAULT => -53
	},
	{#State 30
		DEFAULT => -39
	},
	{#State 31
		DEFAULT => -16
	},
	{#State 32
		ACTIONS => {
			"::-" => 101,
			":=" => 102,
			"=!=" => 104,
			"{" => 103,
			":-" => 105
		},
		DEFAULT => -45
	},
	{#State 33
		DEFAULT => -94
	},
	{#State 34
		ACTIONS => {
			'NAME' => 106
		}
	},
	{#State 35
		DEFAULT => -95
	},
	{#State 36
		ACTIONS => {
			'NAME' => 107
		}
	},
	{#State 37
		ACTIONS => {
			"(" => 108
		}
	},
	{#State 38
		DEFAULT => -106
	},
	{#State 39
		ACTIONS => {
			";" => 109
		},
		DEFAULT => -2
	},
	{#State 40
		ACTIONS => {
			'NAME' => 110
		}
	},
	{#State 41
		DEFAULT => -13
	},
	{#State 42
		DEFAULT => -52
	},
	{#State 43
		DEFAULT => -63
	},
	{#State 44
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -107
	},
	{#State 45
		ACTIONS => {
			"::-" => 101,
			":-" => 105
		},
		DEFAULT => -45
	},
	{#State 46
		ACTIONS => {
			"\@" => 62
		},
		DEFAULT => -73
	},
	{#State 47
		DEFAULT => -45
	},
	{#State 48
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 48,
			'STRING' => 25,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 45,
			"{|" => 14,
			"&" => 36,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -25,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 111,
			'parens' => 7,
			'expr' => 50,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 49
		ACTIONS => {
			"]" => 112
		}
	},
	{#State 50
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"," => 113,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -24
	},
	{#State 51
		ACTIONS => {
			"\@" => 62
		},
		DEFAULT => -82
	},
	{#State 52
		ACTIONS => {
			"," => 114
		},
		DEFAULT => -36
	},
	{#State 53
		DEFAULT => -37
	},
	{#State 54
		ACTIONS => {
			"isa" => 116,
			"byref" => 115,
			"=" => 117
		},
		DEFAULT => -32
	},
	{#State 55
		ACTIONS => {
			"`" => 118
		}
	},
	{#State 56
		DEFAULT => 0
	},
	{#State 57
		ACTIONS => {
			"|" => 119
		}
	},
	{#State 58
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 25,
			"if" => 26,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 32,
			"{|" => 14,
			"var" => 34,
			"&" => 36,
			"while" => 37,
			"module" => 17,
			"defun" => 40,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 28,
			'arrayindex' => 29,
			'multexpr' => 9,
			'module' => 31,
			'powexp' => 33,
			'stma' => 120,
			'value' => 15,
			'standardmath' => 35,
			'ifstartcond' => 16,
			'stmt' => 39,
			'exprnouminus' => 38,
			'assigncomb' => 18,
			'while' => 41,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 59
		ACTIONS => {
			"else" => 121
		},
		DEFAULT => -19
	},
	{#State 60
		ACTIONS => {
			"{" => 58
		},
		GOTOS => {
			'block' => 122
		}
	},
	{#State 61
		ACTIONS => {
			"^=" => 87,
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"**" => 89,
			"+" => 88,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			"^" => 90,
			" " => 76,
			"*" => 77,
			"per" => 91,
			")" => 123,
			"**=" => 78,
			"!=" => 93,
			"&&" => 95,
			"?" => 94,
			"||" => 80,
			"^^" => 96,
			"/" => 97,
			"->" => 81,
			"-=" => 82,
			"=" => 99,
			"+=" => 98,
			"/=" => 83,
			"<=>" => 100,
			"<=" => 84,
			"%=" => 86,
			">" => 85
		}
	},
	{#State 62
		ACTIONS => {
			"{`" => 12,
			'NAME' => 47,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"(" => 19,
			'HEXNUMBER' => 20,
			"[" => 10,
			'NUMBER' => 30
		},
		GOTOS => {
			'parens' => 7,
			'singlevalnoindex' => 124,
			'number' => 23,
			'lambda' => 24,
			'value' => 15
		}
	},
	{#State 63
		DEFAULT => -98
	},
	{#State 64
		DEFAULT => -84
	},
	{#State 65
		ACTIONS => {
			"\@" => 62,
			'DATE' => 3,
			"!" => 8,
			"[" => 10,
			"--" => 11,
			"{`" => 12,
			"{|" => 14,
			"(" => 19,
			'HEXNUMBER' => 20,
			'STRING' => 25,
			"++" => 27,
			'NUMBER' => 30,
			'NAME' => 45,
			"&" => 36
		},
		DEFAULT => -67,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 125,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 66
		DEFAULT => -83
	},
	{#State 67
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 126,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 68
		ACTIONS => {
			"\@" => 62
		},
		DEFAULT => -81
	},
	{#State 69
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 127,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 70
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 128,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 71
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 129,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 72
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 130,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 73
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 131,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 74
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 132,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 75
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 133,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 76
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 134,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 77
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 135,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 78
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 136,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 79
		ACTIONS => {
			'NAME' => 137
		}
	},
	{#State 80
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 138,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 81
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 139,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 82
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 140,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 83
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 141,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 84
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 142,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 85
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 143,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 86
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 144,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 87
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 145,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 88
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 146,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 89
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 147,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 90
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 148,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 91
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 149,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 92
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 150,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 93
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 151,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 94
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 152,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 95
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 153,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 96
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 154,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 97
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 155,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 98
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 156,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 99
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 157,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 100
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 158,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 101
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 159,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 102
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 160,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 103
		ACTIONS => {
			'NAME' => 54
		},
		DEFAULT => -38,
		GOTOS => {
			'arglist' => 161,
			'argelement' => 52,
			'arglistfilled' => 53
		}
	},
	{#State 104
		ACTIONS => {
			'NAME' => 162
		}
	},
	{#State 105
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 163,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 106
		ACTIONS => {
			"=" => 164
		},
		DEFAULT => -5
	},
	{#State 107
		DEFAULT => -48
	},
	{#State 108
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 165,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 109
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 25,
			"if" => 26,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 32,
			"{|" => 14,
			"var" => 34,
			"&" => 36,
			"while" => 37,
			"module" => 17,
			"defun" => 40,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 28,
			'arrayindex' => 29,
			'multexpr' => 9,
			'module' => 31,
			'powexp' => 33,
			'stma' => 166,
			'value' => 15,
			'standardmath' => 35,
			'ifstartcond' => 16,
			'stmt' => 39,
			'exprnouminus' => 38,
			'assigncomb' => 18,
			'while' => 41,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 110
		ACTIONS => {
			"=" => 167
		}
	},
	{#State 111
		DEFAULT => -26
	},
	{#State 112
		DEFAULT => -46
	},
	{#State 113
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 48,
			'STRING' => 25,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 45,
			"{|" => 14,
			"&" => 36,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -25,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 168,
			'parens' => 7,
			'expr' => 50,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 114
		ACTIONS => {
			'NAME' => 54
		},
		GOTOS => {
			'argelement' => 52,
			'arglistfilled' => 169
		}
	},
	{#State 115
		ACTIONS => {
			"isa" => 170
		},
		DEFAULT => -34
	},
	{#State 116
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			"..." => 173,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 172,
			'arrayindex' => 29,
			'multexpr' => 9,
			'constraint' => 171,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 117
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 174,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 118
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 25,
			"if" => 26,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 32,
			"{|" => 14,
			"var" => 34,
			"&" => 36,
			"while" => 37,
			"module" => 17,
			"defun" => 40,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 28,
			'arrayindex' => 29,
			'multexpr' => 9,
			'module' => 31,
			'powexp' => 33,
			'stma' => 175,
			'value' => 15,
			'standardmath' => 35,
			'ifstartcond' => 16,
			'stmt' => 39,
			'exprnouminus' => 38,
			'assigncomb' => 18,
			'while' => 41,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 119
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 25,
			"if" => 26,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 32,
			"{|" => 14,
			"var" => 34,
			"&" => 36,
			"while" => 37,
			"module" => 17,
			"defun" => 40,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 28,
			'arrayindex' => 29,
			'multexpr' => 9,
			'module' => 31,
			'powexp' => 33,
			'stma' => 176,
			'value' => 15,
			'standardmath' => 35,
			'ifstartcond' => 16,
			'stmt' => 39,
			'exprnouminus' => 38,
			'assigncomb' => 18,
			'while' => 41,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 120
		ACTIONS => {
			"}" => 177
		}
	},
	{#State 121
		ACTIONS => {
			"{" => 58
		},
		GOTOS => {
			'block' => 178
		}
	},
	{#State 122
		DEFAULT => -22
	},
	{#State 123
		DEFAULT => -49
	},
	{#State 124
		DEFAULT => -41
	},
	{#State 125
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -68
	},
	{#State 126
		ACTIONS => {
			"^=" => 87,
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"**" => 89,
			"+" => 88,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			"^" => 90,
			" " => 76,
			"*" => 77,
			"per" => 91,
			")" => 179,
			"**=" => 78,
			"!=" => 93,
			"&&" => 95,
			"?" => 94,
			"||" => 80,
			"^^" => 96,
			"/" => 97,
			"->" => 81,
			"-=" => 82,
			"=" => 99,
			"+=" => 98,
			"/=" => 83,
			"<=>" => 100,
			"<=" => 84,
			"%=" => 86,
			">" => 85
		}
	},
	{#State 127
		ACTIONS => {
			"%" => 73,
			" " => 76,
			"*" => 77,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"/" => 97
		},
		DEFAULT => -88
	},
	{#State 128
		ACTIONS => {
			"-" => 69,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"<=" => 84,
			">" => 85,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"/" => 97,
			"<=>" => 100
		},
		DEFAULT => -96
	},
	{#State 129
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -74
	},
	{#State 130
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -58
	},
	{#State 131
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -91
	},
	{#State 132
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -78
	},
	{#State 133
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -77
	},
	{#State 134
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -69
	},
	{#State 135
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -66
	},
	{#State 136
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -60
	},
	{#State 137
		DEFAULT => -11
	},
	{#State 138
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"<=" => 84,
			">" => 85,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"/" => 97,
			"<=>" => 100
		},
		DEFAULT => -71
	},
	{#State 139
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"||" => 80,
			"<=" => 84,
			">" => 85,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"<=>" => 100
		},
		DEFAULT => -104
	},
	{#State 140
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -56
	},
	{#State 141
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -57
	},
	{#State 142
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -76
	},
	{#State 143
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -75
	},
	{#State 144
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -59
	},
	{#State 145
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -61
	},
	{#State 146
		ACTIONS => {
			"%" => 73,
			" " => 76,
			"*" => 77,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"/" => 97
		},
		DEFAULT => -87
	},
	{#State 147
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -85
	},
	{#State 148
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -86
	},
	{#State 149
		ACTIONS => {
			"%" => 73,
			" " => 76,
			"*" => 77,
			"**" => 89,
			"^" => 90,
			"/" => 97
		},
		DEFAULT => -90
	},
	{#State 150
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -9
	},
	{#State 151
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -80
	},
	{#State 152
		ACTIONS => {
			"^=" => 87,
			":" => 180,
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"**" => 89,
			"+" => 88,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			"^" => 90,
			" " => 76,
			"*" => 77,
			"per" => 91,
			"**=" => 78,
			"!=" => 93,
			"&&" => 95,
			"?" => 94,
			"||" => 80,
			"^^" => 96,
			"/" => 97,
			"->" => 81,
			"-=" => 82,
			"=" => 99,
			"+=" => 98,
			"/=" => 83,
			"<=>" => 100,
			"<=" => 84,
			"%=" => 86,
			">" => 85
		}
	},
	{#State 153
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"<=" => 84,
			">" => 85,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"/" => 97,
			"<=>" => 100
		},
		DEFAULT => -70
	},
	{#State 154
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"<=" => 84,
			">" => 85,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"/" => 97,
			"<=>" => 100
		},
		DEFAULT => -72
	},
	{#State 155
		ACTIONS => {
			"**" => 89,
			"^" => 90
		},
		DEFAULT => -89
	},
	{#State 156
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -55
	},
	{#State 157
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -54
	},
	{#State 158
		ACTIONS => {
			"-" => 69,
			"<" => undef,
			"%" => 73,
			"==" => undef,
			">=" => undef,
			" " => 76,
			"*" => 77,
			"<=" => undef,
			">" => undef,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => undef,
			"/" => 97,
			"<=>" => undef
		},
		DEFAULT => -79
	},
	{#State 159
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -102
	},
	{#State 160
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -8
	},
	{#State 161
		ACTIONS => {
			"}" => 181
		}
	},
	{#State 162
		DEFAULT => -10
	},
	{#State 163
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -103
	},
	{#State 164
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 182,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 165
		ACTIONS => {
			"^=" => 87,
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"**" => 89,
			"+" => 88,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			"^" => 90,
			" " => 76,
			"*" => 77,
			"per" => 91,
			")" => 183,
			"**=" => 78,
			"!=" => 93,
			"&&" => 95,
			"?" => 94,
			"||" => 80,
			"^^" => 96,
			"/" => 97,
			"->" => 81,
			"-=" => 82,
			"=" => 99,
			"+=" => 98,
			"/=" => 83,
			"<=>" => 100,
			"<=" => 84,
			"%=" => 86,
			">" => 85
		}
	},
	{#State 166
		DEFAULT => -3
	},
	{#State 167
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 184,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 168
		DEFAULT => -23
	},
	{#State 169
		DEFAULT => -35
	},
	{#State 170
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			"..." => 173,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 172,
			'arrayindex' => 29,
			'multexpr' => 9,
			'constraint' => 185,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 171
		DEFAULT => -30
	},
	{#State 172
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -27
	},
	{#State 173
		DEFAULT => -28
	},
	{#State 174
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"isa" => 186,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -31
	},
	{#State 175
		ACTIONS => {
			"}" => 187
		}
	},
	{#State 176
		ACTIONS => {
			"}" => 188
		}
	},
	{#State 177
		DEFAULT => -17
	},
	{#State 178
		DEFAULT => -20
	},
	{#State 179
		DEFAULT => -18
	},
	{#State 180
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 189,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 181
		ACTIONS => {
			":=" => 190
		}
	},
	{#State 182
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -6
	},
	{#State 183
		ACTIONS => {
			"{" => 58
		},
		GOTOS => {
			'block' => 191
		}
	},
	{#State 184
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -7
	},
	{#State 185
		DEFAULT => -33
	},
	{#State 186
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"&" => 36,
			"..." => 173,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 172,
			'arrayindex' => 29,
			'multexpr' => 9,
			'constraint' => 192,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 187
		DEFAULT => -64
	},
	{#State 188
		DEFAULT => -65
	},
	{#State 189
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"||" => 80,
			"<=" => 84,
			">" => 85,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"<=>" => 100
		},
		DEFAULT => -97
	},
	{#State 190
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 45,
			"{|" => 14,
			'DATE' => 3,
			"{" => 194,
			"&" => 36,
			'STRING' => 25,
			"++" => 27,
			'HEXNUMBER' => 20,
			"!" => 8,
			"(" => 19,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 193,
			'arrayindex' => 29,
			'multexpr' => 9,
			'powexp' => 33,
			'value' => 15,
			'standardmath' => 35,
			'assigncomb' => 18,
			'exprnouminus' => 38,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 191
		DEFAULT => -21
	},
	{#State 192
		DEFAULT => -29
	},
	{#State 193
		ACTIONS => {
			"-" => 69,
			"conforms" => 70,
			"*=" => 72,
			"<" => 71,
			"%" => 73,
			"==" => 74,
			">=" => 75,
			" " => 76,
			"*" => 77,
			"**=" => 78,
			"||" => 80,
			"->" => 81,
			"-=" => 82,
			"/=" => 83,
			"<=" => 84,
			"%=" => 86,
			">" => 85,
			"^=" => 87,
			"+" => 88,
			"**" => 89,
			"^" => 90,
			"per" => 91,
			"!=" => 93,
			"?" => 94,
			"&&" => 95,
			"^^" => 96,
			"/" => 97,
			"+=" => 98,
			"=" => 99,
			"<=>" => 100
		},
		DEFAULT => -14
	},
	{#State 194
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 25,
			"if" => 26,
			"++" => 27,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 30,
			"--" => 11,
			"{`" => 12,
			'NAME' => 32,
			"{|" => 14,
			"var" => 34,
			"&" => 36,
			"while" => 37,
			"module" => 17,
			"defun" => 40,
			"(" => 19,
			'HEXNUMBER' => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 22,
			'number' => 23,
			'lambda' => 24,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 28,
			'arrayindex' => 29,
			'multexpr' => 9,
			'module' => 31,
			'powexp' => 33,
			'stma' => 195,
			'value' => 15,
			'standardmath' => 35,
			'ifstartcond' => 16,
			'stmt' => 39,
			'exprnouminus' => 38,
			'assigncomb' => 18,
			'while' => 41,
			'singlevalnoindex' => 42,
			'assignexpr2' => 43,
			'logic' => 21
		}
	},
	{#State 195
		ACTIONS => {
			"}" => 196
		}
	},
	{#State 196
		DEFAULT => -15
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
#line 33 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 34 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 35 "Farnsworth.yp"
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
		 'stmt', 4,
sub
#line 41 "Farnsworth.yp"
{ bless [ @_[2,4] ], 'DeclareFunc' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 42 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 43 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 44 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 11
		 'stmt', 3,
sub
#line 45 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineCombo' }
	],
	[#Rule 12
		 'stmt', 1, undef
	],
	[#Rule 13
		 'stmt', 1, undef
	],
	[#Rule 14
		 'stmt', 6,
sub
#line 48 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 15
		 'stmt', 8,
sub
#line 49 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 16
		 'stmt', 1, undef
	],
	[#Rule 17
		 'block', 3,
sub
#line 53 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 18
		 'ifstartcond', 4,
sub
#line 55 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 19
		 'if', 2,
sub
#line 58 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 20
		 'if', 4,
sub
#line 59 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 21
		 'while', 5,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[3,5] ], 'While' }
	],
	[#Rule 22
		 'module', 3,
sub
#line 70 "Farnsworth.yp"
{bless [@_[2,3]], 'Module' }
	],
	[#Rule 23
		 'array', 3,
sub
#line 77 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 24
		 'array', 1,
sub
#line 78 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 25
		 'array', 0,
sub
#line 79 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 26
		 'array', 2,
sub
#line 80 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 27
		 'constraint', 1, undef
	],
	[#Rule 28
		 'constraint', 1,
sub
#line 84 "Farnsworth.yp"
{bless [], 'VarArg'}
	],
	[#Rule 29
		 'argelement', 5,
sub
#line 87 "Farnsworth.yp"
{bless [ $_[1], $_[3], $_[5], 0], 'Argele'}
	],
	[#Rule 30
		 'argelement', 3,
sub
#line 88 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3], 0], 'Argele'}
	],
	[#Rule 31
		 'argelement', 3,
sub
#line 89 "Farnsworth.yp"
{bless [ $_[1], $_[3], undef, 0], 'Argele'}
	],
	[#Rule 32
		 'argelement', 1,
sub
#line 90 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 0], 'Argele'}
	],
	[#Rule 33
		 'argelement', 4,
sub
#line 91 "Farnsworth.yp"
{bless [ $_[1], undef, $_[4], 1], 'Argele'}
	],
	[#Rule 34
		 'argelement', 2,
sub
#line 92 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 1], 'Argele'}
	],
	[#Rule 35
		 'arglistfilled', 3,
sub
#line 95 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 36
		 'arglistfilled', 1,
sub
#line 96 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 37
		 'arglist', 1, undef
	],
	[#Rule 38
		 'arglist', 0, undef
	],
	[#Rule 39
		 'number', 1,
sub
#line 103 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 40
		 'number', 1,
sub
#line 104 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 41
		 'arrayindex', 3,
sub
#line 107 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 42
		 'value', 1, undef
	],
	[#Rule 43
		 'value', 1,
sub
#line 111 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 44
		 'value', 1,
sub
#line 112 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 45
		 'value', 1,
sub
#line 113 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 46
		 'value', 3,
sub
#line 114 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 47
		 'value', 1, undef
	],
	[#Rule 48
		 'value', 2,
sub
#line 116 "Farnsworth.yp"
{ bless [ $_[2] ], 'GetFunc' }
	],
	[#Rule 49
		 'parens', 3,
sub
#line 119 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 50
		 'singlevalnoindex', 1, undef
	],
	[#Rule 51
		 'singlevalnoindex', 1, undef
	],
	[#Rule 52
		 'singleval', 1, undef
	],
	[#Rule 53
		 'singleval', 1, undef
	],
	[#Rule 54
		 'assignexpr', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 55
		 'assignexpr2', 3,
sub
#line 133 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreAdd' }
	],
	[#Rule 56
		 'assignexpr2', 3,
sub
#line 134 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreSub' }
	],
	[#Rule 57
		 'assignexpr2', 3,
sub
#line 135 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreDiv' }
	],
	[#Rule 58
		 'assignexpr2', 3,
sub
#line 136 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMul' }
	],
	[#Rule 59
		 'assignexpr2', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMod' }
	],
	[#Rule 60
		 'assignexpr2', 3,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 61
		 'assignexpr2', 3,
sub
#line 139 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 62
		 'assigncomb', 1, undef
	],
	[#Rule 63
		 'assigncomb', 1, undef
	],
	[#Rule 64
		 'lambda', 5,
sub
#line 146 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 65
		 'lambda', 5,
sub
#line 147 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 66
		 'multexpr', 3,
sub
#line 150 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 67
		 'multexpr', 2,
sub
#line 151 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 68
		 'multexpr', 3,
sub
#line 152 "Farnsworth.yp"
{ bless [bless([ @_[1,2], 'imp'], 'Mul'), $_[3], 'imp'], 'Mul' }
	],
	[#Rule 69
		 'multexpr', 3,
sub
#line 153 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 70
		 'logic', 3,
sub
#line 156 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 71
		 'logic', 3,
sub
#line 157 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 72
		 'logic', 3,
sub
#line 158 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 73
		 'logic', 2,
sub
#line 159 "Farnsworth.yp"
{ bless [ $_[2] ], 'Not' }
	],
	[#Rule 74
		 'compare', 3,
sub
#line 162 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 75
		 'compare', 3,
sub
#line 163 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 76
		 'compare', 3,
sub
#line 164 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 77
		 'compare', 3,
sub
#line 165 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 78
		 'compare', 3,
sub
#line 166 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 79
		 'compare', 3,
sub
#line 167 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 80
		 'compare', 3,
sub
#line 168 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 81
		 'crement', 2,
sub
#line 171 "Farnsworth.yp"
{ bless [ $_[2] ], 'PreInc' }
	],
	[#Rule 82
		 'crement', 2,
sub
#line 172 "Farnsworth.yp"
{ bless [ $_[2] ], 'PreDec' }
	],
	[#Rule 83
		 'crement', 2,
sub
#line 173 "Farnsworth.yp"
{ bless [ $_[1] ], 'PostInc' }
	],
	[#Rule 84
		 'crement', 2,
sub
#line 174 "Farnsworth.yp"
{ bless [ $_[1] ], 'PostDec' }
	],
	[#Rule 85
		 'powexp', 3,
sub
#line 177 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 86
		 'powexp', 3,
sub
#line 178 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 87
		 'standardmath', 3,
sub
#line 181 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 88
		 'standardmath', 3,
sub
#line 182 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 89
		 'standardmath', 3,
sub
#line 183 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 90
		 'standardmath', 3,
sub
#line 184 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 91
		 'standardmath', 3,
sub
#line 185 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 92
		 'exprnouminus', 1, undef
	],
	[#Rule 93
		 'exprnouminus', 1, undef
	],
	[#Rule 94
		 'exprnouminus', 1, undef
	],
	[#Rule 95
		 'exprnouminus', 1, undef
	],
	[#Rule 96
		 'exprnouminus', 3,
sub
#line 192 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 97
		 'exprnouminus', 5,
sub
#line 193 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 98
		 'exprnouminus', 2,
sub
#line 194 "Farnsworth.yp"
{ bless [(bless ['factorial'], 'Fetch'), (bless [$_[1]], 'Array') , 'imp'], 'Mul' }
	],
	[#Rule 99
		 'exprnouminus', 1, undef
	],
	[#Rule 100
		 'exprnouminus', 1, undef
	],
	[#Rule 101
		 'exprnouminus', 1, undef
	],
	[#Rule 102
		 'exprnouminus', 3,
sub
#line 198 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 103
		 'exprnouminus', 3,
sub
#line 199 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 104
		 'exprnouminus', 3,
sub
#line 200 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 105
		 'exprnouminus', 1, undef
	],
	[#Rule 106
		 'expr', 1, undef
	],
	[#Rule 107
		 'expr', 2,
sub
#line 205 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 207 "Farnsworth.yp"


#helpers!
my $ws = qr/[^\S\n]/; #whitespace without the \n

sub yylex
	{
	no warnings 'exiting'; #needed because perl doesn't seem to like me using redo there now;
	my $line = $_[-2];
	my $charline = $_[-1];
	my $lastcharline = $_[-3];
	my $gotsingleval = $_[-4];
	
	#remove \n or whatever from the string
	if ($s =~ /\G$ws*\n$ws*/gc)
	{
		$$line++;
		$$lastcharline = $$charline;
		$$charline = pos $s;
		#print "LEX: ${$line} ${$charline} || ".substr($s, $$charline, index($s, "\n", $$charline)-$$charline)."\n";
		redo
	}
	
	#this has got to be the most fucked up work around in the entire code base.
	#i'm doing this to check if i've gotten something like; 2a so that i can insert a fictious space token. so that 2a**2 will properly parse as 2 * (a ** 2) 
	if ($$gotsingleval) #we had a number
	{
	  #print "INGOTNUMBER\n";
	  $$gotsingleval = 0; #unset it
	  if ($s =~ /\G(?=$identifier|
	  	      	0[xb]?[[:xdigit:]](?:[[:xdigit:].]+)| #hex octal or binary numbers
    			(?:\d+(\.\d*)?|\.\d+)(?:[Ee][Ee]?[-+]?\d+)| #scientific notation
    			(?:\d+(?:\.\d*)?|\.\d+)| #plain notation
	    		(?:\($ws*) #paren value
	  )/gcx) #match opening array brace
	  {#<NUMBER><IDENTIFIER> needs a space (or a *, but we'll use \s for now)
	    #print "OMG IDENTIFIER!\n";
	    return ' '; 
	  }
	}
	
	$s =~ /\G\s*(?=\s)/gc; #skip whitespace up to a single space, makes \s+ always look like \s to the rest of the code, simplifies some regex below
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G\s*/\*.*?\*/\s*|gcs and redo; #skip C comments
	$s =~ m|\G\s*//.*(?=\n)?|gc and redo;

    if ($s=~ /\G(?=
        0x[[:xdigit:].]+| #hex octal or binary numbers
        0b[01.]+|
        0[0-7][0-7.]*|
    	(?:\d+(\.\d*)?|\.\d+)(?:[Ee][Ee]?[-+]?\d+)| #scientific notation
    	(?:\d+(?:\.\d*)?|\.\d+)| #plain notation
	    (?:$ws*\)) #paren value
    )/cgx)
    {
       #print "GOT SINGLEVAL!";
       $$gotsingleval = 1; #store the fact that the last token was a number of some kind, so that we can do funky stuff on the next token if its an identifier
    }

    #i want a complete number regex
    #The 'HEXNUMBER' is really just for numbers of different bases, e.g. Hexidecimal, Binary, and Octal
	$s =~ /\G(0x[[:xdigit:].]+)/igc and return 'HEXNUMBER', $1;
	$s =~ /\G(0b[01.]+)/igc and return 'HEXNUMBER', $1;
	$s =~ /\G(0[0-7][0-7.]*)/igc and return 'HEXNUMBER', $1;
		
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;



    #token out the date
    $s =~ /\G\s*#([^#]*)#\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*"((\\.|[^"\\])*)"/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(while|conforms|else|if|module)\b\s*/cg and return $1;

	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	#$s =~ /\G$ws*()$ws*/icg and return lc $1;
	
	#comparators
	$s =~ /\G$ws*(==|!=|<=>|>=|<=)$ws*/icg and return lc $1;
	
	#pre and post decrements, needs to be two statements for \s
	$s =~ /\G$ws*(\+\+|--)$ws*/icg and return lc $1;
	
	#farnsworth specific operators
	$s =~ /\G$ws*(:=|->|:->)$ws*/icg and return lc $1;
	
	$s =~ /\G$ws*(var\b|defun\b|per\b|isa\b|byref\b|\:?\:\-|\=\!\=|\|\|\|)$ws*/icg and return lc $1;
	
	#assignment operators
	$s =~ /\G$ws*(\*\*=|\+=|-=|\*=|\/=|%=|\^=|=)$ws*/icg and return lc $1;
    
    #logical operators
    $s =~ /\G$ws*(\^\^|\&\&|\|\||\!)$ws*/icg and return lc $1;
	
	#math operators
	$s =~ /\G$ws*(\*\*|\+|\*|-|\/|\%|\^)$ws*/icg and return lc $1;
	
	$s =~ /\G$ws*(;|\{\s*\`|\{\s*\||\{|\}|\>|\<|\?|\:|\,|\.\.\.|\`|\|)$ws*/cg and return $1;
	$s =~ /\G$ws*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)$ws*/cg and return $1;
	
	$s =~ /\G($identifier)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
}


sub yylexwatch
{
   my $oldp = pos $s;
   my @r = &yylex;

#   my $charlines = $_[-1];
#   my $line = $_[-2];
#   my $pos = pos $s;

   #print Dumper(\@_);
#   my $nextn = index($s, "\n", $pos+1);
   #":: ".substr($s, $pos, $nextn-$pos+1).
#   print "LEX: ${$line} ${$charlines} $pos :: ".substr($s, $pos, 10)."\n";
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
    my $gotnumber = $_[-4];
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
	my $gotnumber = 0;
	my $self = shift;
	
	$s = join ' ', @_;
	$fullstring = $s; #preserve it for errors
	my $code = eval
		{ $self->new(yylex => sub {yylexwatch(@_, \$lastcharlines, \$line, \$charlines, \$gotnumber)}, yyerror => sub {yyerror(@_, $lastcharlines, $line, $charlines, $gotnumber)})->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
