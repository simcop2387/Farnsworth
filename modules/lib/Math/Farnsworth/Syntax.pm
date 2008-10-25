1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Math::Farnsworth::Syntax - A bunch of examples of all the syntax in Math::Farnsworth

=head1 SYNOPSIS

  use Math::Farnsworth;
  
  my $hubert = Math::Farnsworth->new();

  my $result = $hubert->runString("10 km -> miles");

  my $result = $hubert->runFile("file.frns");

  print $hubert->prettyOut($result);

=head1 DESCRIPTION

Math::Farnsworth is a programming language originally inspired by Frink (see http://futureboy.homeip.net/frinkdocs/ ).
However due to certain difficulties during the creation of it, the syntax has changed slightly and the capabilities are also different.
Some things Math::Farnsworth can do a little better than Frink, other areas Math::Farnsworth lacks.

=head2 PREREQUISITS
Modules and Libraries you need before this will work

* PARI library for L<Math::Pari>
* L<Math::Pari>

The following are optional

	For the Google Translation library
	* L<REST::Google::Translate>
	* L<HTML::Entities>

=head2 EXPORT

None by default.

=head2 KNOWN BUGS
At this time there are no known bugs

=head2 MISSING FEATURES
The following features are currently missing and WILL be implemented in a future version of Math::Farnsworth

* Better control over the output
	* Adjustable precision of numbers
	* Better defaults for certain types of output

* Passing arguments by reference
* Syntax tree introspection inside the language itself

=head1 SEE ALSO

L<Math::Farnsworth::Evaluate> L<Math::Farnsworth::Value> 
L<Math::Farnsworth::Tutorial> L<Math::Farnsworth::Syntax> L<Math::Farnsworth::Functions>

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

There is also an RT tracker for the module (this may change) setup at
L<http://farnsworth.sexypenguins.com/>, you can also reach the tracker by sending an email to E<lt>farnswort.rt@gmail.comE<gt>

=head1 AUTHOR

Ryan Voots E<lt>simcop@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Ryan Voots

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
