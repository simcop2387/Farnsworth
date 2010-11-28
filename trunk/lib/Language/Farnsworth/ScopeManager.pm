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
		
		if ($ns =~ /^UNIT/) #special unit space 
		{
			error "UNIT:: not supported at this time";
		}
		elsif ($ns =~ /^FUNCTION/) #special function space, name not decided
		{
			error "FUNCTION:: not supported at this time";
		}
		else
		{
			return $self->resolve($self->namespaces->{$ns}, $symbol);
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
	
	my $weak = \$scope; # use a weakened ref so that we can keep from having living scopes around
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

1;