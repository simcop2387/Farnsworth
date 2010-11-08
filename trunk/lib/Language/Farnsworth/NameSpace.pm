package Language::Farnsworth::NameSpace;

use Moose;

use Language::Farnsworth::Variables;
use Language::Farnsworth::FunctionDispatch;

has 'functions' => (is=>'rw', isa=>'Language::Farnsworth::FunctionDispatch',
                   default => sub {Language::Farnsworth::FunctionDispatch->new()});
                
has 'scope' => (is => 'rw', isa=>'Language::Farnsworth::Variables',
                default => sub {Language::Farnsworth::Variables->new()});

1;