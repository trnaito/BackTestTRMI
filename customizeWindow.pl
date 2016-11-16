#!/usr/bin/perl

#use warnings;
use strict;

### User input 
print "Place input file to the current directly and type <file name>(space)<t-frame>:\n";
my $userInput = <STDIN>;

### Check there's two inputs with a space
if ($userInput !~ / / ) {
    print "Please put (space) between the file name and the time frame.\n";
    exit(-1);
} 
my @arUserInput = split(' ', $userInput);

### Check if t-frame is in number format
if ($arUserInput[1] !~ /^\d+$/) {
    print "Please type number as <t-frame>.\n";
    exit(-1);
}

open (IN, "< $arUserInput[0]") or die $!;
my $outFile = $arUserInput[0].'-'.$arUserInput[1].'.txt';
my $lineCount = 0;
my @calcLines;
my @calcBuzz;
my @calcZero;

while(<IN>) {
    $lineCount++;
    chomp;

    $_ =~ s/,,/,0,/g;
    $_ =~ s/0,,/0,0,/g;
    $_ =~ s/,$/,0/g;

    push(@calcLines, $_);

    if (($lineCount / $arUserInput[1]) == 1) {
        $lineCount = 0;
        my @ar_id;
        my @ar_assetCode;
        my @ar_windowTimestamp;
        my @ar_dataType;
        my @ar_systemVersion;
        my @ar_buzz;
        my @ar_sentiment;
        my @ar_optimism;
        my @ar_fear;
        my @ar_joy;
        my @ar_trust;
        my @ar_violence;
        my @ar_conflict;
        my @ar_gloom;
        my @ar_stress;
        my @ar_timeUrgency;
        my @ar_uncertainty;
        my @ar_emotionVsFact;
        my @ar_longShort;
        my @ar_longShortForecast;
        my @ar_priceDirection;
        my @ar_priceForecast;
        my @ar_volatility;
        my @ar_loveHate;
        my @ar_anger;
        my @ar_debtDefault;
        my @ar_innovation;
        my @ar_marketRisk;
        my @ar_analystRating;
        my @ar_dividends;
        my @ar_earningsForecast;
        my @ar_fundamentalStrength;
        my @ar_layoffs;
        my @ar_litigation;
        my @ar_managementChange; 
        my @ar_managementTrust;
        my @ar_mergers;

        ##-----------------------------------------
        ## Calculate customized market psych index
        ##-----------------------------------------
        foreach my $elem (@calcLines) {
            @calcZero = split(',', $elem);

            # id 0, assetCode 1, windowTimestamp 2, dataType 3, systemVersion 4
            push(@ar_id, $calcZero[0]);
            push(@ar_assetCode, $calcZero[1]);
            push(@ar_windowTimestamp, $calcZero[2]);
            push(@ar_dataType, $calcZero[3]);
            push(@ar_systemVersion, $calcZero[4]);
            push(@ar_buzz, $calcZero[5]);
            push(@ar_sentiment, $calcZero[6]);
            push(@ar_optimism, $calcZero[7]);
            push(@ar_fear, $calcZero[8]);
            push(@ar_joy, $calcZero[9]);
            push(@ar_trust, $calcZero[10]);
            push(@ar_violence, $calcZero[11]);
            push(@ar_conflict, $calcZero[12]);
            push(@ar_gloom, $calcZero[13]);
            push(@ar_stress, $calcZero[14]);
            push(@ar_timeUrgency, $calcZero[15]);
            push(@ar_uncertainty, $calcZero[16]);
            push(@ar_emotionVsFact, $calcZero[17]);
            push(@ar_longShort, $calcZero[18]);
            push(@ar_longShortForecast, $calcZero[19]);
            push(@ar_priceDirection, $calcZero[20]);
            push(@ar_priceForecast, $calcZero[21]);
            push(@ar_volatility, $calcZero[22]);
            push(@ar_loveHate, $calcZero[23]);
            push(@ar_anger, $calcZero[24]);
            push(@ar_debtDefault, $calcZero[25]);
            push(@ar_innovation, $calcZero[26]);
            push(@ar_marketRisk, $calcZero[27]);
            push(@ar_analystRating, $calcZero[28]); 
            push(@ar_dividends, $calcZero[29]);
            push(@ar_earningsForecast, $calcZero[30]);
            push(@ar_fundamentalStrength, $calcZero[31]);            
            push(@ar_layoffs, $calcZero[32]);
            push(@ar_litigation, $calcZero[33]);
            push(@ar_managementChange, $calcZero[34]);
            push(@ar_managementTrust, $calcZero[35]);
            push(@ar_mergers, $calcZero[36]);
        }

        ## Generate output line
        ##--------------------------------------------------
        my @outLine = ();
        push(@outLine, $ar_id[$#ar_id]);
        push(@outLine, $ar_assetCode[$#ar_assetCode]);
        push(@outLine, $ar_windowTimestamp[$#ar_windowTimestamp]);
        push(@outLine, $ar_dataType[$#ar_dataType]);
        push(@outLine, $ar_systemVersion[$#ar_systemVersion]);

        use List::Util qw/sum/;
        push(@outLine, sum(@ar_buzz));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_sentiment));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_optimism));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_fear));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_joy));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_trust));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_violence));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_conflict));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_gloom));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_stress));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_timeUrgency));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_uncertainty));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_emotionVsFact));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_longShort));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_longShortForecast));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_priceDirection));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_priceForecast));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_volatility));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_loveHate));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_anger));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_debtDefault));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_innovation));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_marketRisk));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_analystRating));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_dividends));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_earningsForecast));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_fundamentalStrength));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_layoffs));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_litigation));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_managementChange));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_managementTrust));
        push(@outLine, &GenerateMI(\@ar_buzz, \@ar_mergers));

        open(OUT, ">> $outFile") or die $!;
        print OUT join (',', @outLine), "\n";
        close(OUT); 
    }
}

close(IN);

print "End of the program.\n";
exit(0);

sub Trim {
    my $val = shift;
    $val =~ s/^\s*(.*?)\s*$/$1/;
    return $val;
}

sub GenerateMI {
    my ($refar_buzz, $refar_emot) = @_;

    use List::Util qw/sum/;
    my $rBuzz = sum(@$refar_buzz);

    my ($arCount, $emotSum, $i) = (0, 0, 0);
    $i=0; 
    foreach $i(@$refar_emot) {
         $emotSum += $i * @$refar_buzz[$arCount];
         $arCount++;
    }
    my $customMI = $emotSum/$rBuzz;
    return $customMI; 
}

