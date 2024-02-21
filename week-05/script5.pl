#!/usr/bin/perl

use strict;
use warnings;

my @args = ();
my @files = ();

foreach my $arg_num (0 .. $#ARGV) {
    if ($ARGV[$arg_num] eq '-c' || $ARGV[$arg_num] eq '-N' || $ARGV[$arg_num] eq '-n' || $ARGV[$arg_num] eq '-p') {
        push(@args, $ARGV[$arg_num])
    }
    elsif ($ARGV[$arg_num] =~ m[-[a-z]|[A-Z]]) {
        print('Invalid argument: ' . $ARGV[$arg_num] . ', skipping...' . "\n")
    }
    else {
        push(@files, $ARGV[$arg_num]);
    }
}

my %params = map {$_ => 1} @args;

if (exists($params{'-c'}) && exists($params{'-n'}) || exists($params{'-c'}) && exists($params{'-p'}) || exists($params{'-p'}) && exists($params{'-n'})) {
    print('Cannot use these arguments together.' . "\n");
    exit 1;
}

my ($number_lines, $skip_comment_lines, $number_separately);

foreach my $arg (@args) {
    if ($arg eq '-c') {
        $number_lines = 1;
    } elsif ($arg eq '-N') {
        $skip_comment_lines = 1;
    } elsif ($arg eq '-n') {
        $number_lines = 1;
        $skip_comment_lines = 1;
    } elsif ($arg eq '-p') {
        $number_lines = 1;
        $number_separately = 1;
    }
}

my $line_number = 0;

sub process_file {
    my ($file) = @_;

    open my $fh, '<', $file or die "Cannot open file $file: $!";

    my $file_line_number = 0;

    while (<$fh>) {
        next if $skip_comment_lines && /^\s*#/;

        if ($number_lines) {
            if ($number_separately) {
                $file_line_number++;
                print "$file_line_number: ";
            }
            else {
                $line_number++;
                print "$line_number: ";
            }
        }

        print $_;
    }

    close $fh;
}

my $length = scalar @files;
if ($length) {
    foreach my $file (@files) {
        process_file($file);
        print "\n";
    }
}
else {
    print('Files were not specified.' . "\n");
    exit 1;
}

exit 0;
