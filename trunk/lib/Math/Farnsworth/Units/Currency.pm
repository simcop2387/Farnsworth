package Math::Farnsworth::Units::Currency;

use strict;
use warnings;

use Data::Dumper;

use Math::Farnsworth::Value;
use Math::Farnsworth::Value::Pari;
use Math::Farnsworth::Units;
use Math::Farnsworth::Error;

use Finance::Currency::Convert::WebserviceX;
#use Finance::Currency::Convert::XE;

#{#this is a REALLY BAD THING TO DO BUT I DON'T WANT NO ROUNDING AT THIS LEVEL
#	no warnings;
#	package Finance::Currency::Convert::XE;
#
#	sub _format
#	{
#		return "%f";
#	}
#}

#note that this is fairly C<en-US> centric!

my $defaultcurrency = "USD";

my $obj = Finance::Currency::Convert::WebserviceX->new()
                || die "Failed to create object\n" ;

#this is a quick and dirty list of proper names and symbols for defining them below
my %symbols = (Baht=>'THB',Balboa=>'PAB',Bolivianos=>'BOB',Cedis=>'GHC', Colon=>'CRC',Colones=>'SVC',
	Cordobas=>'NIO',Denars=>'MKD',Dollars=>'USD',Dong=>'VND',Euro=>'EUR',Forint=>'HUF',Francs=>'CHF',Guarani=>'PYG',
	Guilders=>'ANG',Hryvnia=>'UAH',Kips=>'LAK',Koruny=>'CZK',Krone=>'NOK',Kroner=>'DKK',Kronor=>'SEK',Kronur=>'ISK',Krooni=>'EEK',Kuna=>'HRK',Lati=>'LVL',
	Leke=>'ALL',Lempiras=>'HNL',Liras=>'TRL',Lira=>'TRY',Litai=>'LTL',Nairas=>'NGN',New_Dollars=>'TWD',
	New_Shekels=>'ILS',Pesos=>'MXN',Pounds=>'GBP',Pulas=>'BWP',Quetzales=>'GTQ',Rand=>'ZAR',Reais=>'BRL',Ringgits=>'MYR',Riyals=>'SAR',
	Rubles=>'BYR',Rubles=>'RUB',Rupees=>'INR',Rupiahs=>'IDR',Shillings=>'SOS',Switzerland_Francs=>'CHF',Tenge=>'KZT',Tugriks=>'MNT',
	Won=>'KRW',Yen=>'JPY',Yuan_Renminbi=>'CNY',Zimbabwe_Dollars=>'ZWD',Zlotych=>'PLN');

my @currencies = values %symbols;

sub init
{
	my $env = shift;
	#doupdate([],$env,[]); #ignore this for now

	$env->{funcs}->addfunc("updatecurrencies", [[undef, undef, undef, 0]], \&doupdate);
}

sub doupdate
{
	my ($args, $env, $branches)= @_;
    
	my $lock = $Math::Farnsworth::Units::lock;
	$Math::Farnsworth::Units::lock = 0;

	for my $x (@currencies)
	{
		print "Fetching currency $x\n";
		my $currentval = $obj->convert(100000, $x, "USD");# || die "Could not convert\n";
		
		if ($currentval)
		{
			$env->eval("$x := $currentval / 100000. dollars;");
		}
		else
		{
			print "Can't convert $x\n";
		}
	}

	for my $name (keys %symbols)
	{
		print "Setting up $name\n";
		eval {$env->eval("$name := ".$symbols{$name});};
		if ($@)
		{
			warn $@ if ("".$@ =~ "Undefined symbol"); #ignore ones that aren't there anymore, dunno WHY that happens though, i blame XE
			die $@ if ("".$@ !~ "Undefined symbol"); #ignore ones that aren't there anymore, dunno WHY that happens though, i blame XE
		}
	}

#ignore this for now, it was a bad design anyway
#	$Math::Farnsworth::Units::lock = $lock;

	return undef;
}

1;

