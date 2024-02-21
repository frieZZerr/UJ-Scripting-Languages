#!/usr/bin/perl

use strict;
use warnings;

# Check args
if (@ARGV < 4) {
    die "Usage: $0 DELIMITER NUMBER1 NUMBER2 FILES...\n";
}

my ($delimiter, $start, $end) = @ARGV[0, 1, 2];

unless ($start =~ /^\d+$/ && $end =~ /^\d+$/ && $start >= 0 && $end >= 0) {
    die "Numbers must be integers > 0.\n";
}

my $min = min($start, $end);
my $max = max($start, $end);

foreach my $file (@ARGV[3..$#ARGV]) {
    open my $fh, '<', $file or do {
        warn "Cannot open file $file: $!\n";
        next;
    };

    while (my $line = <$fh>) {
        my @words;
        if ($delimiter eq '\s') {
            @words = split ' ', $line;
        } else {
            @words = split /$delimiter/, $line;
        }

        my @selected_words = defined(@words[$min-1 .. $max-1]) ? @words[$min-1 .. $max-1] : "";
        
        foreach my $element (@selected_words) {
            $element = join('', split(' ', $element));
        }

        print "@selected_words\n";
    }
    
    close $fh;
}

sub min {
    my ($a, $b) = @_;
    return $a < $b ? $a : $b;
}

sub max {
    my ($a, $b) = @_;
    return $a > $b ? $a : $b;
}
