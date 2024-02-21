#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;
use WC;

my ($count_integers, $count_numbers, $exclude_lines);
my @files;

# Check args
while (@ARGV) {
    my $arg = shift @ARGV;

    if ($arg eq '-i')    { $count_integers = 1; }
    elsif ($arg eq '-d') { $count_numbers = 1; }
    elsif ($arg eq '-e') { $exclude_lines = 1; }
    elsif (-e $arg)      { push @files, $arg; }
    else { die "Invalid option or file: $arg\n"; }
}

# Check for files
if (@files == 0) { die "Usage: $0 [-i|-d] [-e] FILE1 FILE2 ...\n"; }

my ($total_lines, $total_words, $total_chars, $total_integers, $total_numbers) = (0, 0, 0, 0, 0);

for my $file (@files) {
    open my $fh, '<', $file or die "Cannot open file $file: $!\n";

    my ($lines, $words, $chars, $integers, $numbers) = (0, 0, 0, 0, 0);

    while (my $line = <$fh>) {
        $lines++;

        if ($exclude_lines && $line =~ /^\s*#/) { next; }

        $words += scalar(split /\s+/, $line);
        $chars += length($line);

        if ($count_integers) { $integers += WC::isInt($line) }

        if ($count_numbers) {
            $numbers += WC::isDec($line) + WC::exDec($line);
        }
    }

    close $fh;

    my $summary = "$lines $words $chars ";
    if ($count_integers) { $summary .= "$integers "; }
    if ($count_numbers)  { $summary .= "$numbers ";  }

    $summary .= "$file\n";
    print "$summary";

    $total_lines += $lines;
    $total_words += $words;
    $total_chars += $chars;
    $total_integers += $integers;
    $total_numbers += $numbers;
}

if(@files > 1) {
	my $summary = "$total_lines $total_words $total_chars ";
    if ($count_integers) { $summary .= "$total_integers "; }
    if ($count_numbers ) { $summary .= "$total_numbers ";  }

    $summary .= "total\n";
    print "$summary";
}
