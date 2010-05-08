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
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'lambda' => 23,
			'number' => 22,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 13,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 1
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 38,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 2
		DEFAULT => -91
	},
	{#State 3
		DEFAULT => -37
	},
	{#State 4
		DEFAULT => -92
	},
	{#State 5
		DEFAULT => -54
	},
	{#State 6
		DEFAULT => -11
	},
	{#State 7
		DEFAULT => -45
	},
	{#State 8
		ACTIONS => {
			"{`" => 12,
			'NAME' => 41,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"(" => 18,
			'HEXNUMBER' => 19,
			"[" => 10,
			'NUMBER' => 28
		},
		GOTOS => {
			'parens' => 7,
			'singleval' => 40,
			'number' => 22,
			'lambda' => 23,
			'value' => 15
		}
	},
	{#State 9
		DEFAULT => -85
	},
	{#State 10
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 42,
			'STRING' => 24,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 39,
			"{|" => 14,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 43,
			'parens' => 7,
			'expr' => 44,
			'multexpr' => 9,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 11
		ACTIONS => {
			"{`" => 12,
			'NAME' => 41,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"(" => 18,
			'HEXNUMBER' => 19,
			"[" => 10,
			'NUMBER' => 28
		},
		GOTOS => {
			'parens' => 7,
			'singleval' => 45,
			'number' => 22,
			'lambda' => 23,
			'value' => 15
		}
	},
	{#State 12
		ACTIONS => {
			'NAME' => 48
		},
		DEFAULT => -33,
		GOTOS => {
			'arglist' => 49,
			'argelement' => 46,
			'arglistfilled' => 47
		}
	},
	{#State 13
		ACTIONS => {
			'' => 50
		}
	},
	{#State 14
		ACTIONS => {
			'NAME' => 48
		},
		DEFAULT => -33,
		GOTOS => {
			'arglist' => 51,
			'argelement' => 46,
			'arglistfilled' => 47
		}
	},
	{#State 15
		DEFAULT => -44
	},
	{#State 16
		ACTIONS => {
			"{" => 53
		},
		GOTOS => {
			'ifstmts' => 52
		}
	},
	{#State 17
		DEFAULT => -98
	},
	{#State 18
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 54,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 19
		DEFAULT => -35
	},
	{#State 20
		DEFAULT => -90
	},
	{#State 21
		ACTIONS => {
			"\@" => 55,
			'DATE' => 3,
			"[" => 10,
			"--" => 56,
			"{`" => 12,
			"{|" => 14,
			'HEXNUMBER' => 19,
			"(" => 18,
			'STRING' => 24,
			"++" => 58,
			'NUMBER' => 28,
			'NAME' => 41
		},
		DEFAULT => -84,
		GOTOS => {
			'parens' => 7,
			'singleval' => 57,
			'number' => 22,
			'lambda' => 23,
			'value' => 15
		}
	},
	{#State 22
		DEFAULT => -36
	},
	{#State 23
		DEFAULT => -42
	},
	{#State 24
		DEFAULT => -38
	},
	{#State 25
		ACTIONS => {
			"(" => 59
		}
	},
	{#State 26
		ACTIONS => {
			"{`" => 12,
			'NAME' => 41,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"(" => 18,
			'HEXNUMBER' => 19,
			"[" => 10,
			'NUMBER' => 28
		},
		GOTOS => {
			'parens' => 7,
			'singleval' => 60,
			'number' => 22,
			'lambda' => 23,
			'value' => 15
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"|||" => 71,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			":->" => 84,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -4
	},
	{#State 28
		DEFAULT => -34
	},
	{#State 29
		ACTIONS => {
			"::-" => 93,
			":=" => 94,
			"=!=" => 96,
			"{" => 95,
			":-" => 97
		},
		DEFAULT => -40
	},
	{#State 30
		DEFAULT => -86
	},
	{#State 31
		ACTIONS => {
			'NAME' => 98
		}
	},
	{#State 32
		DEFAULT => -87
	},
	{#State 33
		ACTIONS => {
			"(" => 99
		}
	},
	{#State 34
		DEFAULT => -99
	},
	{#State 35
		ACTIONS => {
			";" => 100
		},
		DEFAULT => -2
	},
	{#State 36
		DEFAULT => -12
	},
	{#State 37
		DEFAULT => -55
	},
	{#State 38
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -100
	},
	{#State 39
		ACTIONS => {
			"::-" => 93,
			"{" => 95,
			":-" => 97
		},
		DEFAULT => -40
	},
	{#State 40
		ACTIONS => {
			"\@" => 55
		},
		DEFAULT => -65
	},
	{#State 41
		DEFAULT => -40
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 42,
			'STRING' => 24,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 39,
			"{|" => 14,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 101,
			'parens' => 7,
			'expr' => 44,
			'multexpr' => 9,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 43
		ACTIONS => {
			"]" => 102
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"," => 103,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -19
	},
	{#State 45
		ACTIONS => {
			"\@" => 55
		},
		DEFAULT => -74
	},
	{#State 46
		ACTIONS => {
			"," => 104
		},
		DEFAULT => -31
	},
	{#State 47
		DEFAULT => -32
	},
	{#State 48
		ACTIONS => {
			"isa" => 106,
			"byref" => 105,
			"=" => 107
		},
		DEFAULT => -27
	},
	{#State 49
		ACTIONS => {
			"`" => 108
		}
	},
	{#State 50
		DEFAULT => 0
	},
	{#State 51
		ACTIONS => {
			"|" => 109
		}
	},
	{#State 52
		ACTIONS => {
			"else" => 110
		},
		DEFAULT => -15
	},
	{#State 53
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 111,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 54
		ACTIONS => {
			"^=" => 79,
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"**" => 81,
			"+" => 80,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			"^" => 82,
			" " => 68,
			"*" => 69,
			"per" => 83,
			")" => 112,
			"**=" => 70,
			"!=" => 85,
			"&&" => 87,
			"?" => 86,
			"||" => 72,
			"^^" => 88,
			"/" => 89,
			"->" => 73,
			"-=" => 74,
			"=" => 91,
			"+=" => 90,
			"/=" => 75,
			"<=>" => 92,
			"<=" => 76,
			"%=" => 78,
			">" => 77
		}
	},
	{#State 55
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			"," => 42,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"(" => 18,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 113,
			'parens' => 7,
			'expr' => 44,
			'multexpr' => 9,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 56
		DEFAULT => -76
	},
	{#State 57
		ACTIONS => {
			"\@" => 55,
			'DATE' => 3,
			"!" => 8,
			"[" => 10,
			"--" => 11,
			"{`" => 12,
			"{|" => 14,
			"(" => 18,
			'HEXNUMBER' => 19,
			'STRING' => 24,
			"++" => 26,
			'NUMBER' => 28,
			'NAME' => 39
		},
		DEFAULT => -59,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 114,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 58
		DEFAULT => -75
	},
	{#State 59
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 115,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 60
		ACTIONS => {
			"\@" => 55
		},
		DEFAULT => -73
	},
	{#State 61
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 116,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 62
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 117,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 63
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 118,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 64
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 119,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 65
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 120,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 66
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 121,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 67
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 122,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 68
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 123,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 69
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 124,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 70
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 125,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 71
		ACTIONS => {
			'NAME' => 126
		}
	},
	{#State 72
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 127,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 73
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 128,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 74
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 129,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 75
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 130,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 76
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 131,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 77
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 132,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 78
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 133,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 79
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 134,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 80
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 135,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 81
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 136,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 82
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 137,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 83
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 138,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 84
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 139,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 85
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 140,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 86
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 141,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 87
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 142,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 88
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 143,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 89
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 144,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 90
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 145,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 91
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 146,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 92
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 147,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 93
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 148,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 94
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 149,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 95
		ACTIONS => {
			'NAME' => 48
		},
		DEFAULT => -33,
		GOTOS => {
			'arglist' => 150,
			'argelement' => 46,
			'arglistfilled' => 47
		}
	},
	{#State 96
		ACTIONS => {
			'NAME' => 151
		}
	},
	{#State 97
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 152,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 98
		ACTIONS => {
			"=" => 153
		},
		DEFAULT => -5
	},
	{#State 99
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 154,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 100
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 155,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 101
		DEFAULT => -21
	},
	{#State 102
		DEFAULT => -41
	},
	{#State 103
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			"," => 42,
			'STRING' => 24,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 39,
			"{|" => 14,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -20,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'array' => 156,
			'parens' => 7,
			'expr' => 44,
			'multexpr' => 9,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 104
		ACTIONS => {
			'NAME' => 48
		},
		GOTOS => {
			'argelement' => 46,
			'arglistfilled' => 157
		}
	},
	{#State 105
		ACTIONS => {
			"isa" => 158
		},
		DEFAULT => -29
	},
	{#State 106
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			"..." => 161,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 160,
			'multexpr' => 9,
			'constraint' => 159,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 107
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 162,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 108
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 163,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 109
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 164,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 110
		ACTIONS => {
			"{" => 53
		},
		GOTOS => {
			'ifstmts' => 165
		}
	},
	{#State 111
		ACTIONS => {
			"}" => 166
		}
	},
	{#State 112
		DEFAULT => -43
	},
	{#State 113
		ACTIONS => {
			"\$" => 167
		}
	},
	{#State 114
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -60
	},
	{#State 115
		ACTIONS => {
			"^=" => 79,
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"**" => 81,
			"+" => 80,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			"^" => 82,
			" " => 68,
			"*" => 69,
			"per" => 83,
			")" => 168,
			"**=" => 70,
			"!=" => 85,
			"&&" => 87,
			"?" => 86,
			"||" => 72,
			"^^" => 88,
			"/" => 89,
			"->" => 73,
			"-=" => 74,
			"=" => 91,
			"+=" => 90,
			"/=" => 75,
			"<=>" => 92,
			"<=" => 76,
			"%=" => 78,
			">" => 77
		}
	},
	{#State 116
		ACTIONS => {
			"%" => 65,
			" " => 68,
			"*" => 69,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"/" => 89
		},
		DEFAULT => -80
	},
	{#State 117
		ACTIONS => {
			"-" => 61,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"<=" => 76,
			">" => 77,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"/" => 89,
			"<=>" => 92
		},
		DEFAULT => -88
	},
	{#State 118
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -66
	},
	{#State 119
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -50
	},
	{#State 120
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -83
	},
	{#State 121
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -70
	},
	{#State 122
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -69
	},
	{#State 123
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -61
	},
	{#State 124
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -58
	},
	{#State 125
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -52
	},
	{#State 126
		DEFAULT => -10
	},
	{#State 127
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"<=" => 76,
			">" => 77,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"/" => 89,
			"<=>" => 92
		},
		DEFAULT => -63
	},
	{#State 128
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"||" => 72,
			"<=" => 76,
			">" => 77,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"<=>" => 92
		},
		DEFAULT => -97
	},
	{#State 129
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -48
	},
	{#State 130
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -49
	},
	{#State 131
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -68
	},
	{#State 132
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -67
	},
	{#State 133
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -51
	},
	{#State 134
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -53
	},
	{#State 135
		ACTIONS => {
			"%" => 65,
			" " => 68,
			"*" => 69,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"/" => 89
		},
		DEFAULT => -79
	},
	{#State 136
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -77
	},
	{#State 137
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -78
	},
	{#State 138
		ACTIONS => {
			"%" => 65,
			" " => 68,
			"*" => 69,
			"**" => 81,
			"^" => 82,
			"/" => 89
		},
		DEFAULT => -82
	},
	{#State 139
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -8
	},
	{#State 140
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -72
	},
	{#State 141
		ACTIONS => {
			"^=" => 79,
			":" => 169,
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"**" => 81,
			"+" => 80,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			"^" => 82,
			" " => 68,
			"*" => 69,
			"per" => 83,
			"**=" => 70,
			"!=" => 85,
			"&&" => 87,
			"?" => 86,
			"||" => 72,
			"^^" => 88,
			"/" => 89,
			"->" => 73,
			"-=" => 74,
			"=" => 91,
			"+=" => 90,
			"/=" => 75,
			"<=>" => 92,
			"<=" => 76,
			"%=" => 78,
			">" => 77
		}
	},
	{#State 142
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"<=" => 76,
			">" => 77,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"/" => 89,
			"<=>" => 92
		},
		DEFAULT => -62
	},
	{#State 143
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"<=" => 76,
			">" => 77,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"/" => 89,
			"<=>" => 92
		},
		DEFAULT => -64
	},
	{#State 144
		ACTIONS => {
			"**" => 81,
			"^" => 82
		},
		DEFAULT => -81
	},
	{#State 145
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -47
	},
	{#State 146
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -46
	},
	{#State 147
		ACTIONS => {
			"-" => 61,
			"<" => undef,
			"%" => 65,
			"==" => undef,
			">=" => undef,
			" " => 68,
			"*" => 69,
			"<=" => undef,
			">" => undef,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => undef,
			"/" => 89,
			"<=>" => undef
		},
		DEFAULT => -71
	},
	{#State 148
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -93
	},
	{#State 149
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -7
	},
	{#State 150
		ACTIONS => {
			"}" => 170
		}
	},
	{#State 151
		DEFAULT => -9
	},
	{#State 152
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -94
	},
	{#State 153
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 171,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 154
		ACTIONS => {
			"^=" => 79,
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"**" => 81,
			"+" => 80,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			"^" => 82,
			" " => 68,
			"*" => 69,
			"per" => 83,
			")" => 172,
			"**=" => 70,
			"!=" => 85,
			"&&" => 87,
			"?" => 86,
			"||" => 72,
			"^^" => 88,
			"/" => 89,
			"->" => 73,
			"-=" => 74,
			"=" => 91,
			"+=" => 90,
			"/=" => 75,
			"<=>" => 92,
			"<=" => 76,
			"%=" => 78,
			">" => 77
		}
	},
	{#State 155
		DEFAULT => -3
	},
	{#State 156
		DEFAULT => -18
	},
	{#State 157
		DEFAULT => -30
	},
	{#State 158
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			"..." => 161,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 160,
			'multexpr' => 9,
			'constraint' => 173,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 159
		DEFAULT => -25
	},
	{#State 160
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -22
	},
	{#State 161
		DEFAULT => -23
	},
	{#State 162
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"isa" => 174,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -26
	},
	{#State 163
		ACTIONS => {
			"}" => 175
		}
	},
	{#State 164
		ACTIONS => {
			"}" => 176
		}
	},
	{#State 165
		DEFAULT => -16
	},
	{#State 166
		DEFAULT => -14
	},
	{#State 167
		DEFAULT => -39
	},
	{#State 168
		DEFAULT => -13
	},
	{#State 169
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 177,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 170
		ACTIONS => {
			":=" => 178
		}
	},
	{#State 171
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -6
	},
	{#State 172
		ACTIONS => {
			"{" => 179
		}
	},
	{#State 173
		DEFAULT => -28
	},
	{#State 174
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			"..." => 161,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 160,
			'multexpr' => 9,
			'constraint' => 180,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'assigncomb' => 17,
			'exprnouminus' => 34,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 175
		DEFAULT => -56
	},
	{#State 176
		DEFAULT => -57
	},
	{#State 177
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"||" => 72,
			"<=" => 76,
			">" => 77,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"<=>" => 92
		},
		DEFAULT => -89
	},
	{#State 178
		ACTIONS => {
			"{`" => 12,
			"-" => 1,
			'NAME' => 39,
			"{|" => 14,
			'DATE' => 3,
			"{" => 182,
			'STRING' => 24,
			"++" => 26,
			'HEXNUMBER' => 19,
			"!" => 8,
			"(" => 18,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11
		},
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'powexp' => 30,
			'number' => 22,
			'lambda' => 23,
			'value' => 15,
			'standardmath' => 32,
			'crement' => 4,
			'assignexpr' => 5,
			'exprnouminus' => 34,
			'parens' => 7,
			'assigncomb' => 17,
			'expr' => 181,
			'assignexpr2' => 37,
			'multexpr' => 9,
			'logic' => 20
		}
	},
	{#State 179
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 183,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 180
		DEFAULT => -24
	},
	{#State 181
		ACTIONS => {
			"-" => 61,
			"conforms" => 62,
			"*=" => 64,
			"<" => 63,
			"%" => 65,
			"==" => 66,
			">=" => 67,
			" " => 68,
			"*" => 69,
			"**=" => 70,
			"||" => 72,
			"->" => 73,
			"-=" => 74,
			"/=" => 75,
			"<=" => 76,
			"%=" => 78,
			">" => 77,
			"^=" => 79,
			"+" => 80,
			"**" => 81,
			"^" => 82,
			"per" => 83,
			"!=" => 85,
			"?" => 86,
			"&&" => 87,
			"^^" => 88,
			"/" => 89,
			"+=" => 90,
			"=" => 91,
			"<=>" => 92
		},
		DEFAULT => -95
	},
	{#State 182
		ACTIONS => {
			"-" => 1,
			'DATE' => 3,
			'STRING' => 24,
			"if" => 25,
			"++" => 26,
			"!" => 8,
			"[" => 10,
			'NUMBER' => 28,
			"--" => 11,
			"{`" => 12,
			'NAME' => 29,
			"{|" => 14,
			"var" => 31,
			"while" => 33,
			"(" => 18,
			'HEXNUMBER' => 19
		},
		DEFAULT => -1,
		GOTOS => {
			'compare' => 2,
			'singleval' => 21,
			'number' => 22,
			'lambda' => 23,
			'crement' => 4,
			'if' => 6,
			'assignexpr' => 5,
			'parens' => 7,
			'expr' => 27,
			'multexpr' => 9,
			'stma' => 184,
			'powexp' => 30,
			'value' => 15,
			'standardmath' => 32,
			'ifstartcond' => 16,
			'stmt' => 35,
			'exprnouminus' => 34,
			'assigncomb' => 17,
			'while' => 36,
			'assignexpr2' => 37,
			'logic' => 20
		}
	},
	{#State 183
		ACTIONS => {
			"}" => 185
		}
	},
	{#State 184
		ACTIONS => {
			"}" => 186
		}
	},
	{#State 185
		DEFAULT => -17
	},
	{#State 186
		DEFAULT => -96
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
#line 52 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 15
		 'if', 2,
sub
#line 55 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 16
		 'if', 4,
sub
#line 56 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 17
		 'while', 7,
sub
#line 64 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 18
		 'array', 3,
sub
#line 71 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 19
		 'array', 1,
sub
#line 72 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 20
		 'array', 0,
sub
#line 73 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 21
		 'array', 2,
sub
#line 74 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 22
		 'constraint', 1, undef
	],
	[#Rule 23
		 'constraint', 1,
sub
#line 78 "Farnsworth.yp"
{bless [], 'VarArg'}
	],
	[#Rule 24
		 'argelement', 5,
sub
#line 81 "Farnsworth.yp"
{bless [ $_[1], $_[3], $_[5], 0], 'Argele'}
	],
	[#Rule 25
		 'argelement', 3,
sub
#line 82 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3], 0], 'Argele'}
	],
	[#Rule 26
		 'argelement', 3,
sub
#line 83 "Farnsworth.yp"
{bless [ $_[1], $_[3], undef, 0], 'Argele'}
	],
	[#Rule 27
		 'argelement', 1,
sub
#line 84 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 0], 'Argele'}
	],
	[#Rule 28
		 'argelement', 4,
sub
#line 85 "Farnsworth.yp"
{bless [ $_[1], undef, $_[4], 1], 'Argele'}
	],
	[#Rule 29
		 'argelement', 2,
sub
#line 86 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 1], 'Argele'}
	],
	[#Rule 30
		 'arglistfilled', 3,
sub
#line 89 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 31
		 'arglistfilled', 1,
sub
#line 90 "Farnsworth.yp"
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
#line 97 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 35
		 'number', 1,
sub
#line 98 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 36
		 'value', 1, undef
	],
	[#Rule 37
		 'value', 1,
sub
#line 102 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 38
		 'value', 1,
sub
#line 103 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 39
		 'value', 4,
sub
#line 104 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 40
		 'value', 1,
sub
#line 105 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 41
		 'value', 3,
sub
#line 106 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 42
		 'value', 1, undef
	],
	[#Rule 43
		 'parens', 3,
sub
#line 110 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 44
		 'singleval', 1, undef
	],
	[#Rule 45
		 'singleval', 1, undef
	],
	[#Rule 46
		 'assignexpr', 3,
sub
#line 117 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 47
		 'assignexpr2', 3,
sub
#line 120 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreAdd' }
	],
	[#Rule 48
		 'assignexpr2', 3,
sub
#line 121 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreSub' }
	],
	[#Rule 49
		 'assignexpr2', 3,
sub
#line 122 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreDiv' }
	],
	[#Rule 50
		 'assignexpr2', 3,
sub
#line 123 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMul' }
	],
	[#Rule 51
		 'assignexpr2', 3,
sub
#line 124 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StoreMod' }
	],
	[#Rule 52
		 'assignexpr2', 3,
sub
#line 125 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 53
		 'assignexpr2', 3,
sub
#line 126 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'StorePow' }
	],
	[#Rule 54
		 'assigncomb', 1, undef
	],
	[#Rule 55
		 'assigncomb', 1, undef
	],
	[#Rule 56
		 'lambda', 5,
sub
#line 133 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 57
		 'lambda', 5,
sub
#line 134 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 58
		 'multexpr', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 59
		 'multexpr', 2,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 60
		 'multexpr', 3,
sub
#line 139 "Farnsworth.yp"
{ bless [bless([ @_[1,2], 'imp'], 'Mul'), $_[3], 'imp'], 'Mul' }
	],
	[#Rule 61
		 'multexpr', 3,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 62
		 'logic', 3,
sub
#line 143 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 63
		 'logic', 3,
sub
#line 144 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 64
		 'logic', 3,
sub
#line 145 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 65
		 'logic', 2,
sub
#line 146 "Farnsworth.yp"
{ bless [ $_[2] ], 'Not' }
	],
	[#Rule 66
		 'compare', 3,
sub
#line 149 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 67
		 'compare', 3,
sub
#line 150 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 68
		 'compare', 3,
sub
#line 151 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 69
		 'compare', 3,
sub
#line 152 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 70
		 'compare', 3,
sub
#line 153 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 71
		 'compare', 3,
sub
#line 154 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 72
		 'compare', 3,
sub
#line 155 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 73
		 'crement', 2,
sub
#line 158 "Farnsworth.yp"
{ bless [ $_[2] ], 'PreInc' }
	],
	[#Rule 74
		 'crement', 2,
sub
#line 159 "Farnsworth.yp"
{ bless [ $_[2] ], 'PreDec' }
	],
	[#Rule 75
		 'crement', 2,
sub
#line 160 "Farnsworth.yp"
{ bless [ $_[1] ], 'PostInc' }
	],
	[#Rule 76
		 'crement', 2,
sub
#line 161 "Farnsworth.yp"
{ bless [ $_[1] ], 'PostDec' }
	],
	[#Rule 77
		 'powexp', 3,
sub
#line 164 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 78
		 'powexp', 3,
sub
#line 165 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 79
		 'standardmath', 3,
sub
#line 168 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 80
		 'standardmath', 3,
sub
#line 169 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 81
		 'standardmath', 3,
sub
#line 170 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 82
		 'standardmath', 3,
sub
#line 171 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 83
		 'standardmath', 3,
sub
#line 172 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 84
		 'exprnouminus', 1, undef
	],
	[#Rule 85
		 'exprnouminus', 1, undef
	],
	[#Rule 86
		 'exprnouminus', 1, undef
	],
	[#Rule 87
		 'exprnouminus', 1, undef
	],
	[#Rule 88
		 'exprnouminus', 3,
sub
#line 179 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 89
		 'exprnouminus', 5,
sub
#line 180 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 90
		 'exprnouminus', 1, undef
	],
	[#Rule 91
		 'exprnouminus', 1, undef
	],
	[#Rule 92
		 'exprnouminus', 1, undef
	],
	[#Rule 93
		 'exprnouminus', 3,
sub
#line 184 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 94
		 'exprnouminus', 3,
sub
#line 185 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 95
		 'exprnouminus', 6,
sub
#line 186 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 96
		 'exprnouminus', 8,
sub
#line 187 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 97
		 'exprnouminus', 3,
sub
#line 188 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 98
		 'exprnouminus', 1, undef
	],
	[#Rule 99
		 'expr', 1, undef
	],
	[#Rule 100
		 'expr', 2,
sub
#line 193 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 195 "Farnsworth.yp"


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
    	0[xb]?[[:xdigit:]](?:[[:xdigit:].]+)| #hex octal or binary numbers
    	(?:\d+(\.\d*)?|\.\d+)(?:[Ee][Ee]?[-+]?\d+)| #scientific notation
    	(?:\d+(?:\.\d*)?|\.\d+)| #plain notation
	    (?:$ws*\)) #paren value
    )/cgx)
    {
       #print "GOT SINGLEVAL!";
       $$gotsingleval = 1; #store the fact that the last token was a number of some kind, so that we can do funky stuff on the next token if its an identifier
    }

    #i want a complete number regex
	$s =~ /\G(0[xb]?[[:xdigit:]](?:[[:xdigit:].]+))/igc and return 'HEXNUMBER', $1;
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
	
	$s =~ /\G\s*(while|conforms|else|if)\b\s*/cg and return $1;

	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	#$s =~ /\G$ws*()$ws*/icg and return lc $1;
	
	#comparators
	$s =~ /\G$ws*(==|!=|<=>|>=|<=)$ws*/icg and return lc $1;
	
	#pre and post decrements, needs to be two statements for \s
	$s =~ /\G$ws*(\+\+|--)$ws*/icg and return lc $1;
	
	#farnsworth specific operators
	$s =~ /\G$ws*(:=|->|:->)$ws*/icg and return lc $1;
	
	$s =~ /\G$ws*(var\b|per\b|isa\b|byref\b|\:?\:\-|\=\!\=|\|\|\|)$ws*/icg and return lc $1;
	
	#assignment operators
	$s =~ /\G$ws*(\*\*=|\+=|-=|\*=|\/=|%=|\^=|=)$ws*/icg and return lc $1;
    
    #logical operators
    $s =~ /\G$ws*(\^\^|\&\&|\|\||\!)$ws*/icg and return lc $1;
	
	#math operators
	$s =~ /\G$ws*(\*\*|\+|\*|-|\/|\%|\^)$ws*/icg and return lc $1;
	
	$s =~ /\G$ws*(;|\{\s*\`|\{\s*\||\{|\}|\>|\<|\?|\:|\,|\.\.\.|\`)$ws*/cg and return $1;
	$s =~ /\G$ws*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)$ws*/cg and return $1;
	
	$s =~ /\G($identifier)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
}


sub yylexwatch
{
   #my $oldp = pos $s;
   my @r = &yylex;

   #my $charlines = $_[-1];
   #my $line = $_[-2];
   #my $pos = pos $s;

   #print Dumper(\@_);
   #my $nextn = index($s, "\n", $pos+1);
   #print "LEX: ${$line} ${$charlines} $pos :: ".substr($s, $pos, $nextn).":: ".substr($s, $pos, $nextn-$pos+1)."\n";
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
