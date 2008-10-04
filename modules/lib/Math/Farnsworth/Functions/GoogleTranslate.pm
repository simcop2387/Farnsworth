package Math::Farnsworth::Functions::GoogleTranslate;

use strict;
use warnings;

use Data::Dumper;

use Math::Farnsworth::Value;

use REST::Google::Translate;

use Encode;

#note that this is fairly C<en> centric!
sub init
{
	my $env = shift;

    REST::Google::Translate->http_referer('http://www.google.com/'); #for now, i need a real website for this!

	my %langs = (ar=>"Arabic", bg=>"Bulgarian", ca=>"Catalan", cs=>"Czech",
				 da=>"Danish", de=>"German", el=>"Greek", en=>"English", 
				 es=>"Spanish", fi=>"Finnish", fr=>"French", hi=>"Hindi",
				 hr=>"Croatian", id=>"Indonesian", it=>"Italian", iw=>"Hebrew", 
				 ja=>"Japanese", ko=>"Korean", lt=>"Lithuanian", lv=>"Latvian",
				 nl=>"Dutch", no=>"Norwegian", pl=>"Polish", pt=>"Portuguese",
				 ro=>"Romanian", ru=>"Russian", sk=>"Slovak", sl=>"Slovenian", 
				 sr=>"Serbian", sv=>"Swedish", tl=>"Filipino", uk=>"Ukrainian",
				 vi=>"Vietnamese", "zh-CN"=>"Chinese_Simplified", "zh-CN"=>"Chinese",  #bug here! two chineses!
				 "zh-TW"=>"Chinese_Traditional");
	
	#generate lang to lang
	for my $x (keys %langs)
	{
		for my $y (keys %langs)
		{
			if ($x ne $y)
			{
				#no need to generate names for DutchToDutch!
				my $name = $langs{$x}."To".$langs{$y};

				#closures in perl will give me this! closures FTW!
				$env->{funcs}->addfunc($name, [], sub {translate($x,$y,@_)});
			}
		}
	}

	#now generate ToLang Lang, and FromLang
	for my $x (keys %langs)
	{
		my $name = $langs{$x};

		#closures in perl will give me this! closures FTW!
		$env->{funcs}->addfunc($name, [], sub {translate("en",$x,@_)});
		$env->{funcs}->addfunc("To".$name, [], sub {translate("en",$x,@_)});
		$env->{funcs}->addfunc("From".$name, [], sub {translate($x, "en",@_)});
	}
}

sub translate
{
  my ($langa, $langb) = (shift(), shift()); #get the two targets
  my ($args, $eval, $branches)= @_;
	
  #i THINK I HAVE A BUG HERE!
  print Dumper($args);
  if (!$args->{dimen}{dimen}{string})
  {
	  die "First argument to translations must be a string";
  }
  
  #WTF BUG!
  my $totranslate = $args->{pari};
  
  my $res = REST::Google::Translate->new(
              q => $totranslate,
                langpair => "$langa|$langb",
       );

  die "response status failure when translating, ".$res->responseStatus if $res->responseStatus != 200;

  my $translated = $res->responseData->translatedText;

  print "TRANSLATED: $langa|$langb '$translated'\n";
  print Dumper($res);

  #$translated = decode("UTF-8", $translated); #make sure its interpreted as utf8?

  $translated = new Math::Farnsworth::Value($translated, {string=>1});

  return $translated; #if its undef, its undef! i should really make some kind of error checking here
}

1;
