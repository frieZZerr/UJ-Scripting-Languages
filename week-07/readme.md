# Generalized Word Count (wc) - with modules

This Perl script provides functionality similar to the system `wc` command with additional options for counting numbers. It includes:

- `-d`: Count all numbers, including those in various scientific notations (e.g., e/E/d/D/q/Q/^).
- `-i`: Count only integers.
- `-e`: Exclude lines starting with the '#' character from the counting process.

Without specifying any options, the script behaves like the system `wc` command, providing counts per file and total counts for all files together. If only one file is processed, no summary is provided.

Options `-h`, `-v`, and `-L` may or may not be implemented. The `-m` option is implemented only if supported. Long options (e.g., `--help`) can also be implemented if desired.

## Usage Example
- `perl script1.pl [options] file1.txt file2.txt ...`
