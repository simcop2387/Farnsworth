package Language::Farnsworth::ScopeManager;

use 5.010;
use Moose;

use Language::Farnsworth::Error;
use Language::Farnsworth::NameSpace;

use Data::Dumper;

use Scalar::Util qw(weaken refaddr);

has 'scopes' => (is => 'rw', isa=>'HashRef', default => sub {return {}});
has 'namespaces' => (is => 'rw', isa => 'HashRef', default => sub {return {}});

sub resolvesymbol
{
	my $self = shift;
	my $scope = shift;
	my $symbol = shift;
	
	if ($symbol =~ /^(.*)::([^:]*)$/) # we have a new scope!
	{
		my $ns = $1;
		my $symbol = $2;
		
		if ($ns =~ /^U(NIT)?::/)
		{
			error "Namespaced UNIT:: is unsupported";
		}
		elsif ($ns =~ /^UNIT/ || $ns eq "U") #special unit space 
		{
			if ($scope->units->isunit($symbol))
			{
				return $scope->units->getunit($symbol);
			}
			else
			{
				error "No such unit '$symbol'";
			}
		}
		elsif ($ns =~ /^F(UNCTION)?/) #special function space, name not decided
		{
			my $rns = $ns;
			$rns =~ s/^F(UNCTION)?(::)?//; #remove the FUNCTION, we need to grab the right namespace
			
			my $scope = $self->getspace($rns);
			
			if ($scope->functions->isfunc($symbol))
			{
				return $scope->functions->getfunc($symbol)->{lambda};
			}
			else
			{
				error "Undefined function '$symbol'";			
			}			
		}
		else
		{
			return $self->resolve($self->getspace($ns), $symbol);
		}
	}	
	elsif ($scope->scope->isvar($symbol))
	{
		return $scope->scope->getvar($symbol);
	}
	elsif ($scope->units->isunit($symbol))
	{
		return $scope->units->getunit($symbol);
	}
	else
	{
		error "Undefined symbol '$symbol'";
	}
}

sub makechildscope
{
	my $self = shift;
	my $parentspace = shift;
	
	my $scope = Language::Farnsworth::Variables->new($parentspace->scope);
	
	my $weak = \$scope; # use a weakened ref so that we can keep from having living scopes around, while still finding out when we do
	weaken($weak);
	
	$self->scopes->{refaddr($scope)} = $weak;
	
	$parentspace->new({units=>$parentspace->units, scope=>$scope, functions=>$parentspace->functions});
}

sub makeeval
{
	my $self = shift;
	my $parenteval = shift;

	my $newscope = $self->makechildscope($parenteval->vars);

    my %nopts = (ns => $newscope);

    my $neweval = $parenteval->new(%nopts);
	
	return $neweval;
}

sub makenamespace
{
	my ($self, $name) = @_;
	
	error "" unless defined $name;
	error "attempting to redefine existing namespace.  might just have it return later, but now it's an error." if exists($self->namespaces()->{$name});
	
#	warn "makenamespace";
	
	$self->namespaces()->{$name} = Language::Farnsworth::NameSpace->new();
};

sub getspace
{
	my ($self, $ns) = @_;
	
	my $nss = $self->namespaces();
	
	return $nss->{$ns} if (exist($nss->{$ns}));
	
	error "No such namespace $ns";
}

1;