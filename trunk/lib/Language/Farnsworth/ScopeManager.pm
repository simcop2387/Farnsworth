package Language::Farnsworth::ScopeManager;

use 5.010;
use Moose;

use Language::Farnsworth::Error;
use Language::Farnsworth::NameSpace;

use Data::Dumper;

use Scalar::Util qw(weaken refaddr);

has 'scopes' => (is => 'rw', isa=>'Hash', default => {});
has 'namespaces' => (is => 'rw', isa => 'Hash', default => {});

sub resolvesymbol
{
	my $self = shift;
	my $scope = shift;
	my $symbol = shift;
		
	if ($scope->vars->isvar($symbol))
	{
		return $scope->vars->getvar($symbol);
	}
	elsif ($scope->units->isunit($symbol))
	{
		return $scope->units->getunit($symbol);
	}
	else
	{
		error "Undefined symbol '$symbol'\n";
	}
}

sub makescope
{
	my $self = shift;
	my $parentscope = shift;
	
	my $scope = Language::Farnsworth::Variables->new($parentscope->vars);
	
	my $weak = \$scope; # use a weakened ref so that we can keep from having living scopes around
	weaken($weak);
	
	$self->scopes->{refaddr($scope)} = $weak;
}

sub makeeval
{
	my $self = shift;
	my $parenteval = shift;

	my $newscope = $self->makescope($parenteval->{vars});

    my %nopts = (ns => $newscope, funcs => $parenteval->{funcs}, units => $parenteval->{units}, parser => $parenteval->{parser});

    my $neweval = $parenteval->new(%nopts);
	
	return $neweval;
}

sub makenamespace
{
	my ($self, $name) = @_;
	
	error "" unless defined $name;
	error "attempting to redefine existing namespace.  might just have it return later, but now it's an error." if exists($self->namespace()->{$name});
	
	$self->namespace()->{$name} = Language::Farnsworth::NameSpace->new();
}