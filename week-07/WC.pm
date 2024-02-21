#!/usr/bin/perl

package WC;

use strict;
use warnings;

sub isInt {
    my $line = $_[0];
    return $line =~ m/(?<!\.)(?<!e-)(?<!E-)(?<!d-)(?<!D-)(?<!\^)\b[0-9]+\b(?!\.)(?!\^)/;
}

sub isDec {
    my $line = $_[0];
    return $line =~ m/(?<!q)(?<!Q)[0-9]+(\.)[0-9]+/;
}

sub exDec {
    my $line = $_[0];
    my $dec;
    $dec += () = ($line =~ m/(?<!\.)(?<!e-)(?<!E-)(?<!d-)(?<!D-)(?<!\^)\b[0-9]+\b(?!\.)(?!\^)/ ||
                  $line =~ m/(?<!q)(?<!Q)[0-9]+(\.)[0-9]+/ ||
                  $line =~ m/[0-9]+(e-?)[0-9]+/ ||
                  $line =~ m/[0-9]+(E-?)[0-9]+/ ||
                  $line =~ m/(q)(?<!Q)[0-9]+(\.)[0-9]+/ ||
                  $line =~ m/(Q)(?<!Q)[0-9]+(\.)[0-9]+/ ||
                  $line =~ m/[0-9]+(d-?)[0-9]+/ ||
                  $line =~ m/[0-9]+(D-?)[0-9]+/ ||
                  $line =~ m/[0-9]+(\^-?)[0-9]+/
                );
    return $dec;
}

1
