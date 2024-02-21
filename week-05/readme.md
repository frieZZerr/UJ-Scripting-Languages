# Perl Script with Options

This Perl script is controlled by options:

- Without any options, it outputs to stdout (or possibly stderr) all lines of all files without numbering them (similar to the first script above).

- `-c`: Numbers all lines, including those not displayed if the `-N` option is also used (similar to the second script above).

- `-N`: Does not output to stdout lines starting with the `#` character (similar to the third script above).

- `-n`: Numbers only the displayed lines, as seen in the `-c` option. How to handle the combination of these options in a single invocation is up to you.

- `-p`: Numbers the lines separately for each file, starting from 1 (similar to the fourth script above).

Options are positional, meaning if they appear, they must precede all file names to process. Options may not be present at all, may be one or more, with up to three making sense. Regarding the fourth option, as mentioned earlier, the decision is up to you, as is the handling of repeating any option.

If something appears that looks like an option but is not one of those described above, the behavior is up to you.

## Usage Example
- `perl script5.pl [-c] [-N] [-n] [-p] file1.txt file2.txt ...`
