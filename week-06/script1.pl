#!/usr/bin/perl

use strict;
use warnings;

# Check args
if (@ARGV < 3) {
    die "Usage: $0 NUMBER1 NUMBER2 FILES...\n";
}

my ($start, $end) = @ARGV[0, 1];

unless ($start =~ /^\d+$/ && $end =~ /^\d+$/ && $start >= 0 && $end >= 0) {
    die "Numbers must be integers > 0.\n";
}

my $min = min($start, $end);
my $max = max($start, $end);

foreach my $file (@ARGV[2..$#ARGV]) {
    open my $fh, '<', $file or do {
        warn "Cannot open file $file: $!\n";
        next;
    };

    while (my $line = <$fh>) {
        my @words = split ' ', $line;

        my @selected_words = @words[$min-1 .. $max-1];
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
