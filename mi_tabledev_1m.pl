#!/usr/bin/perl

use strict;
use utf8;
use DBI;
use DDP;


# connection to QA Direct
#-------------------------
my $dbh_qad=DBI->connect('dbi:ODBC:qad','Ryoichi.Naito','Ryoichi') or die $!;


# connection to local MySQL
#--------------------------
my $local_db = 'dbi:mysql:qrd:127.0.0.1';
my $local_us = 'root';
my $local_pw = 'Bingo0941';
my $dbh_qrd = DBI->connect($local_db, $local_us, $local_pw,
				{ RaiseError => 1, AutoCommit => 0 });


# all Japanese stocks in Datastream table
#-----------------------------------------
my $sql_qad = <<"EOD";
select distinct InfoCode from Ds2CtryQtInfo where PrimISOCurrCode='JPY' and IsPrimQt=1 and DsLocalCode is not null
EOD

my $sth_qad=$dbh_qad->prepare($sql_qad) or die $dbh_qad->errstr;
$sth_qad->execute or die $dbh_qad->errstr;

my @infocode;
while(my $row_ref = $sth_qad->fetch) {
	foreach my $i (0..@$row_ref-1) {
		push(@infocode, $row_ref->[$i]);
	}
}


# all tradedate for 6758 Sony
#-----------------------------
my $sql_qad = <<"EOD";
select MarketDate from vw_Ds2Pricing where InfoCode=46222 and IsPrimExchQt='Y' and AdjType=1 and MarketDate>='2006-3-1' order by MarketDate desc
EOD

my $sth_qad=$dbh_qad->prepare($sql_qad) or die $dbh_qad->errstr;
$sth_qad->execute or die $dbh_qad->errstr;

my @tradedate_array;
while(my $row_ref = $sth_qad->fetch) {
        foreach my $i (0..@$row_ref-1) {
                push(@tradedate_array, $row_ref->[$i]);
        }
}


foreach my $var_i(@infocode) {
	foreach my $var_t(@tradedate_array) {
		my $sql_qad = <<"EOD";

select distinct
	right(i.DsLocalCode, 4) as 'code'
,	convert(nvarchar, p1.MarketDate, 112) as 'tradedate'
,	p2.Close_ as 'price'
,	p2.Volume as 'volume'
,	null as 'shares'
,	p1.CumAdjFactor as 'split'
,	p1.Close_ as 'adj_price'
,	p1.Currency as 'currency'
,	p1.Open_ as 'open'
,	p1.High as 'high'
,	p1.Low as 'low'
,	p1.InfoCode as 'infocode'
,	m.MktCap as 'mktcap'
from
	vw_Ds2Pricing p1
	left join vw_Ds2Pricing p2 on p1.InfoCode=p2.InfoCode and p1.MarketDate=p2.MarketDate and p2.AdjType=0
	left join Ds2CtryQtInfo i on p1.InfoCode=i.InfoCode and p2.InfoCode=i.InfoCode
	left join vw_Ds2MktCap m on p1.InfoCode=m.InfoCode and p1.MarketDate=m.MarketDate
where
	p1.InfoCode= $var_i
	and i.DsLocalCode is not null
	and p2.Close_ is not null
	and p1.MarketDate = '$var_t'
	and p1.IsPrimExchQt='Y'
	and p2.IsPrimExchQt='Y'
	and p1.AdjType=1
EOD

		my $sth_qad=$dbh_qad->prepare($sql_qad) or die $dbh_qad->errstr;
		$sth_qad->execute or die $dbh_qad->errstr;
		while(my $ary_ref = $sth_qad->fetchrow_arrayref) {
			my ($code_, $tradedate_, $price_, $volume, $shares, $split, $adj_price, $currency, $open, $high, $low, $infocode, $mktcap) = @$ary_ref;

			if($code_ eq '') { 
				$code_ = 'NULL';
			}
			if($tradedate_ eq '') {
				$tradedate_ = 'NULL';
			}
			if($price_ eq '') {
				$price_ = 'NULL';
			}
			if($volume eq '') {
				$volume = 'NULL';
			}
			if($shares eq '') {
				$shares = 'NULL';
			}
			if($split eq '') {
				$split = 'NULL';
			}
			if($adj_price eq '') {
				$adj_price = 'NULL';
			}
			if($currency eq '') {
				$currency = 'NULL';
			}
			if($open eq '') {
				$open = 'NULL';
			}
			if($high eq '') {
				$high = 'NULL';
			}
			if($low eq '') {
				$low = 'NULL';
			}
			if($infocode eq '') {
				$infocode = 'NULL';
			}
			if($mktcap eq '') {
				$mktcap = 'NULL';
			}

			print "Inserting data of "."unko $code_, $tradedate_, $price_, $volume, $shares, $split, $adj_price, $currency, $open, $high, $low, $infocode, $mktcap\n";
			my $sql_qrd = "insert into PRICE values('$code_','$tradedate_', $price_, $volume, $shares, $split, $adj_price, '$currency', $open, $high, $low, $infocode, $mktcap);";
			print $sql_qrd,"\n";

			my $sth_qrd=$dbh_qrd->prepare($sql_qrd) or die $dbh_qrd->errstr;
			$sth_qrd->execute or die $dbh_qrd->errstr;
		}
		$dbh_qrd->commit;
	}
}

print $sql_qad,"\n";

$sth_qad->finish;
$dbh_qad->disconnect;
$dbh_qrd->disconnect;


