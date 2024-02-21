#!/usr/bin/perl

use strict;
use warnings;

# Check args
if (@ARGV < 1) {
    die "Usage: $0 file1 [file2 ...]\n";
}

foreach my $input_file (@ARGV) {
    open my $fh, '<', $input_file or die "Cannot open file $input_file: $!\n";

    my @data = <$fh>;
    close $fh;

    my $output = create_report(@data);

    my $output_file = $input_file;
    $output_file =~ s/\..+$/\.oceny/;
    open my $out_fh, '>', $output_file or die "Cannot open file $output_file for writing: $!\n";
    print $out_fh @data, $output;
    close $out_fh;

    print "Saved data from $input_file to $output_file\n";
}

sub create_report {
    my @data = @_;

    my %grades;
    my $name;

    foreach my $line (@data) {
        my @elements = split /\s+/, $line;

        my $name = ucfirst lc "$elements[0]";
        my $surname = ucfirst lc "$elements[1]";

        my $full_name = "$name $surname";
        my $grade = process_grade($elements[2]);
        push @{$grades{$full_name}}, $grade;
    }
    
    my $output = "\n";
    foreach my $person (keys %grades) {
        my $average = calculate_average(@{$grades{$person}});
        $output .= "$person Lista ocen: @{$grades{$person}} Średnia: $average\n";
    }

    return $output;
}

sub process_grade {
    my ($grade) = @_;
    my $add = 0;

    $grade =~ s/([+-])(\d)/$2$1/ if $grade =~ /[+-]\d/;

    if ($grade =~ /\+$/) { $add += 0.25; }
    if ($grade =~ /-$/)  { $add -= 0.25; }

    $grade =~ s/\+//g;
    $grade =~ s/\-//g;

    if ($grade =~ /^(\d+(\.\d+)?)$/) {
        $grade = $1;

        if ($grade >= 1 && $grade <= 6) {
            return $grade+$add;
        }
    } else {
        warn "Wrong format: $grade\n";
    }

    return;
}

sub calculate_average {
    my @grades = @_;
    my $sum = 0;
    foreach my $grade (@grades) {
        $sum += $grade;
    }
    my $average = @grades ? $sum / @grades : 0;
    return sprintf("%.2f", $average);
}
