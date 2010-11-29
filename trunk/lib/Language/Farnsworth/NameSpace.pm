package Language::Farnsworth::NameSpace;

use Moose;
use Carp qw(cluck);

use Language::Farnsworth::Variables;
use Language::Farnsworth::FunctionDispatch;
use Language::Farnsworth::Units;
use Language::Farnsworth::Error;

has 'functions' => (is=>'rw', isa=>'Language::Farnsworth::FunctionDispatch',
                   default => sub {Language::Farnsworth::FunctionDispatch->new()});
                
has 'scope' => (is => 'rw', isa=>'Language::Farnsworth::Variables',
                default => sub {Language::Farnsworth::Variables->new()});
                
has 'units' => (is => 'rw', isa=>'Language::Farnsworth::Units', default => sub {Language::Farnsworth::Units->new()});

1;