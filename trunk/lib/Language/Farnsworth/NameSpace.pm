package Language::Farnsworth::NameSpace;

use Moose;

use Language::Farnsworth::Variables;
use Language::Farnsworth::FunctionDispatch;
use Language::Farnsworth::Units;
use Language::Farnsworth::Error;

has 'functions' => (is=>'rw', isa=>'Language::Farnsworth::FunctionDispatch',
                   default => sub {Language::Farnsworth::FunctionDispatch->new()});
                
has 'scope' => (is => 'rw', isa=>'Language::Farnsworth::Variables',
                default => sub {Language::Farnsworth::Variables->new()});
                
has 'units' => (is => 'rw', isa=>'Language::Farnsworth::Units', default => sub {Language::Farnsworth::Units->new()});

sub makechildscope
{
	my $self = shift;
	return $self->new({scope => Language::Farnsworth::Variables->new($self->scope()), 
		               units => $self->units(),
	                   functions => $self->functions()});
}

sub resolveterm
{
	my $self = shift;
	my $term = shift;
	
	if ($self->scope->isvar($term))
	{
		return $self->scope->getvar($term);
	}
	elsif ($self->units->isunit($term))
	{
		return $self->units->getunit($term);
	}
	else
	{
		error "Undefined symbol '$term'\n";
	}
}

1;