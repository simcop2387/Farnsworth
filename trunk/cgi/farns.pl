#!/usr/bin/perl
use strict;
use warnings;

use Template;
use CGI;
use WWW::Mechanize;
use URI::Escape;
use Encode;


my $cgi=new CGI;
print $cgi->header();

my $vars={codeoutput => "", inputcode=>""};

$vars->{inputcode} = $cgi->param('inputcode') if (defined($cgi->param('inputcode')));

if ($vars->{inputcode} ne "")
{
  my $ua = WWW::Mechanize->new(agent => "irc://irc.freenode.net/perl frinkbot madeby simcop2387");
  my $eq = $vars->{inputcode};

  #set the escape for \cpn to be newline
  $eq =~ s/(\cp|\\cp)n/\n/g;

  $eq = uri_escape($eq);

  my $url="http://farnsworth:8080/$eq";

  my $resp = $ua->get($url);

  if ($resp->is_success)
  {
    my $q = $ua->content();
    $q = decode("UTF-8", $q);

    $q =~ s/^\s+//;

    $vars->{codeoutput}=$q;
  }
  else
  {
    $vars->{codeoutput}= "OH DEAR GOD NO! ".$resp->status_line;
  }
}
my $tt = Template->new({
}) || die "$Template::ERROR\n";

$tt->process(\*DATA, $vars) || die $tt->error(), "\n";

__DATA__

<html>
<head>
<title>RUN FARNSWORTH CODE AND DO STUFF TO ME</title>
</head>
<body>
<pre>[%codeoutput%]
</pre>
<hr/>
<form action="http://farnsworth.simcop2387.info/cgi-bin/farns.pl" method="post">
<textarea name="inputcode" cols="80" rows="25">[%inputcode%]</textarea><br/>
<input type="submit"/>
<input type="reset"/>
</form>
</html>
