%left ';'
%right '='
%nonassoc '<' '>' '==' '!=' '>=' '<='
%right 'print'
%left '+' '-'
%left '*' '/' '%'
%left '^'

%{
my $s;		# warning - not re-entrant
%}

%%

stmt
	:									{ bless [ ], 'Stmt' }
	|	expr						{ bless [ $_[1] ], 'Stmt' }
	|	expr ';' stmt		{ bless [ $_[1], @{$_[3]} ], 'Stmt' }
	|	';' stmt				{ $_[2] }
	|	nosemi stmt			{ bless [ $_[1], @{$_[2]} ], 'Stmt' }
	;

nosemi :	while |	for ;

for :	'for' '(' expr ';' expr ';' expr ')' '{' stmt '}'
			{ bless [ @_[3,5,7,10] ], 'For' }
	;

while : 'while' '(' expr ')' '{' stmt '}'
			{ bless [ @_[3,6] ], 'While' }
	;

expr
	:	NUMBER			{ bless [ $_[1] ],   'Num' }
	|	expr '+' expr	{ bless [ @_[1,3] ], 'Add' }
	|	expr '-' expr	{ bless [ @_[1,3] ], 'Sub' }
	|	expr '*' expr	{ bless [ @_[1,3] ], 'Mul' }
	|	expr '/' expr	{ bless [ @_[1,3] ], 'Div' }
	|	expr '%' expr	{ bless [ @_[1,3] ], 'Mod' }
	|	expr '^' expr	{ bless [ @_[1,3] ], 'Pow' }
	|	expr '<' expr	{ bless [ @_[1,3] ], 'Lt' }
	|	expr '>' expr	{ bless [ @_[1,3] ], 'Gt' }
	|	expr '<=' expr	{ bless [ @_[1,3] ], 'Le' }
	|	expr '>=' expr	{ bless [ @_[1,3] ], 'Ge' }
	|	expr '==' expr	{ bless [ @_[1,3] ], 'Eq' }
	|	expr '!=' expr	{ bless [ @_[1,3] ], 'Ne' }
	|	NAME			{ bless [ $_[1] ],   'Fetch' }
	|	NAME '=' expr	{ bless [ @_[1,3] ], 'Store' }
	|   NAME array      { bless [ $_[1,2] ], 'FuncCall' }
	|	'(' expr ')'		{ $_[2] }
	;
%%

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
