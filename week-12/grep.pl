#!/usr/bin/perl

use strict;
use warnings;

sub grep_in_directory {
    my ($directory, $pattern) = @_;
    my $count = 0;

    eval {
        opendir(my $dh, $directory) or die "Cannot open directory $directory: $!";
        while (my $file = readdir($dh)) {
            next if $file =~ /^\./;
            my $file_path = "$directory/$file";
            if (-f $file_path) {
                open my $fh, '<', $file_path or die "Cannot open file $file_path: $!";
                while (my $line = <$fh>) {
                    if ($line =~ /$pattern/) {
                        $count++;
                    }
                }
                close $fh;
            } elsif (-d $file_path) {
                $count += grep_in_directory($file_path, $pattern);
            }
        }
        closedir($dh);
    };

    if ($@) {
        warn "Error processing directory $directory: $@";
    }

    return $count;
}

sub main {
    my @directories;
    my $current_pattern;

    my $i = 0;
    while ($i < @ARGV) {
        if ($ARGV[$i] eq "-d") {
            $i++;
            if ($i < @ARGV) {
                my $directory = $ARGV[$i];
                push @directories, $directory;
                $current_pattern = undef;
            } else {
                die "Error: Missing directory after -d\n";
            }
        } else {
            $current_pattern = $ARGV[$i];
            foreach my $directory (@directories) {
                my $count = grep_in_directory($directory, $current_pattern);
                print "$directory: $count matches for '$current_pattern'\n";
            }
        }
        $i++;
    }
}

main();
