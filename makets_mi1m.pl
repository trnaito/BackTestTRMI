#!/usr/bin/perl

use warnings;
use strict;
use DateTime;

my $datadir = "./";
opendir(DIR, $datadir);
my @FILES = readdir(DIR);
closedir(DIR);

foreach(@FILES) {
    if($_ =~ /txt|csv/i) {
        print "The file name is $_, correct? (Y/N)\n";
        my $line = <STDIN>;
        chomp($line);
        if($line eq 'Y') {
            my $file = $_;

            # split each file for News_Social, News, Social
            SplitFiles($file);

            # make time-series data for each file
            MakeTimeSeries($file);

            exit;
        } else {
        }
    }
} 

sub SplitFiles {
    # initial definitions
    my $file = $_[0];

    my $outfile_ns = "./$file"."ns.txt";
    my $outfile_so = "./$file"."so.txt";
    my $outfile_ne = "./$file"."ne.txt";

    open(IN, "<$file");
    open(IN_NS, ">$outfile_ns") or die $!;
    open(IN_SO, ">$outfile_so") or die $!;
    open(IN_NE, ">$outfile_ne") or die $!;

    while(<IN>) {
        chomp;
        my @line = split(/\t/, $_); 

        if($line[3] eq 'News_Social') {
            print IN_NS join(',', @line), "\n";
        } elsif($line[3] eq 'Social') {
            print IN_SO join(',', @line), "\n";
        } elsif($line[3] eq 'News') {
            print IN_NE join(',', @line), "\n";
        }
    }
    close(IN);
    close(IN_NS);
    close(IN_SO);
    close(IN_NE);
}


sub MakeTimeSeries {

    my $sourceFile = $_[0];
    my $tsFile_ns = "ns_ts.txt";
    my $tsFile_so = "so_ts.txt";
    my $tsFile_ne = "ne_ts.txt";
    my $lineCount = 0;

    # Initialization for datetime variables;
    my $curWindowTimeStamp='';
    my $curWTS_yea='';
    my $curWTS_mon='';
    my $curWTS_day='';
    my $curWTS_hou='';
    my $curWTS_min='';
    my $lastDt='';
    my $lastDt1m='';
    my $curDt='';

    # dataType=News_Social ---------------------
    my $inFile = $sourceFile."ns.txt";

    print "Working on News_Social : $inFile\n";
    open(TSIN, "<$inFile");
    open(TSNS, ">$tsFile_ns") or die $!;
    print "opening $inFile to read..\n";

    while(<TSIN>) {
        chomp($_);
        my @dline = split(/,/, $_);
        $curWindowTimeStamp = $dline[2];

        $curWTS_yea = substr($curWindowTimeStamp, 0, 4);
        $curWTS_mon = substr($curWindowTimeStamp, 5, 2);
        $curWTS_day = substr($curWindowTimeStamp, 8, 2);
        $curWTS_hou = substr($curWindowTimeStamp, 11, 2);
        $curWTS_min = substr($curWindowTimeStamp, 14, 2);

        # The first line with no header
        if($lineCount==0) {
            $lastDt = DateTime->new(year=>$curWTS_yea, month=>$curWTS_mon, day=>$curWTS_day,
                                    hour=>$curWTS_hou, minute=>$curWTS_min);
            $lastDt1m = $lastDt->add(minutes=>1);
            print TSNS join(',', @dline), "\n";
        }
        else {
            $curDt = DateTime->new(year=>$curWTS_yea, month=>$curWTS_mon, day=>$curWTS_day,
                                   hour=>$curWTS_hou, minute=>$curWTS_min);

            if($curDt == $lastDt1m) {
                print TSNS join(',', @dline), "\n";
                $lastDt1m = $curDt->add(minutes=>1);
            }
            else {
                print "not matched.\n";
                exit;
            }
        }
        $lineCount++;
    }
    close(TSIN);
    close(TSNS);
}

exit(0);

