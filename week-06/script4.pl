#!/usr/bin/perl

use strict;
use warnings;

# Check args
if (@ARGV < 4) {
    die "Usage: $0 DELIMITER NUMBER1 NUMBER2 FILES...\n";
}

my ($delimiter, $word1, $word2) = @ARGV[0, 1, 2];

unless ($word1 =~ /^\d+$/ && $word2 =~ /^\d+$/ && $word1 >= 0 && $word2 >= 0) {
    die "Numbers must be integers > 0.\n";
}

foreach my $file (@ARGV[3..$#ARGV]) {
    open my $fh, '<', $file or do {
        warn "Cannot open file $file: $!\n";
        next;
    };

    my $line_number = 0;

    while (my $line = <$fh>) {
        $line_number++;

        my @words = split /$delimiter/, $line;

        if ($word1 <= @words && $word2 <= @words) {
            
            my $res1 = join('', split(' ', $words[$word1 - 1]));
            my $res2 = join('', split(' ', $words[$word2 - 1]));

            print($res1 . " " . $res2 . "\n");
        } else {
            warn "No words at $word1 in file $file\n";
        }
    }

    close $fh;
}
