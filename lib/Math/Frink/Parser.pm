package Math::Frink::Parser;

use strict;
use warnings;

use Parse::RecDescent;


1;
__DATA__
#grammar goes here

   OP       : m([-+*/% ])      # Mathematical operators, white space implies mutliplication
   NUMBER  : /[-+]?(\d+(\.\d+)?([eE]\d+)?)/      # Signed arbitrary sized numbers
   VARIABLE : /\w[a-z0-9_]*/i # Variable

__END__
=cut
POD GOES HERE
