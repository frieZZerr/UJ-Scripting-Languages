# Field Extractor with White Space Delimiter

## Script 1

### How It Works
The script reads the specified range of fields from each file, delimited by white space, and prints them to the standard output. If any file is unreadable, an error message is printed to stderr.

### Usage Example
- `perl script1.pl [first_field] [last_field] file1.txt file2.txt ...`

## Script 2

This Perl script behaves similarly to the previous one, but with a different functionality:

- The first two arguments specify the range of two words to be output. For example, if `3 1` is provided, the script outputs them in that order: first word 3, then word 1. If either of the data is missing, the line is ignored, meaning it is not printed, and an appropriate error message with the line number and file name is printed to stderr.

### Usage Example
- `perl script2.pl [word_range1 word_range2] file1.txt file2.txt ...`

## Script 3

This Perl script is similar to `script1.pl`, but with a custom delimiter specified as the FIRST ARGUMENT. 

Additionally, leading and trailing white spaces are removed from all printed fields. This adjustment is crucial when the delimiter is not a space, unlike in the previous version.

### Usage Example
- `perl script3.pl delimiter [word_range1 word_range2] file1.txt file2.txt ...`

## Script 4

This Perl script is an enhanced version of `script2.pl`, with the same modification of removing leading and trailing white spaces from all printed fields. 

### Usage Example
- `perl script4.pl delimiter [word_range1 word_range2] file1.txt file2.txt ...`
