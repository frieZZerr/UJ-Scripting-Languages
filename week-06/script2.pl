#!/usr/bin/perl

use strict;
use warnings;

# Check args
if (@ARGV < 3) {
    die "Usage: $0 NUMBER1 NUMBER2 FILES...\n";
}

my ($word1, $word2) = @ARGV[0, 1];

unless ($word1 =~ /^\d+$/ && $word2 =~ /^\d+$/ && $word1 >= 0 && $word2 >= 0) {
    die "Numbers must be integers > 0.\n";
}

foreach my $file (@ARGV[2..$#ARGV]) {
    open my $fh, '<', $file or do {
        warn "Cannot open file $file: $!\n";
        next;
    };

    my $line_number = 0;

    while (my $line = <$fh>) {
        $line_number++;

        my @words = split ' ', $line;

        if ($word1 <= @words && $word2 <= @words) {
            print "$words[$word1-1] $words[$word2-1]\n";
        } else {
            warn "No words at $word1 in file $file\n";
        }
    }

    close $fh;
}
