# File Explorer Script - Python vs Perl vs Bash

The **File Explorer Script** allows you to search through directories (recursively) for specified phrases within files. Directories are specified using the `-d` option, followed by the directory path. Phrases to search for are specified after the directory options and are not directories themselves. 

## Usage Example

```bash
./grep.py -d ~/lib -d ~/scripts pier -d ~/bin dru
```

## Performance Test Results
The performance test was conducted using the Bash, Perl and the Python script. Three scripts were executed on several large files to compare their efficiency in processing a significant number of lines.

The test results demonstrate that:
- The average execution time of the scripts shows that in this case, Python and Perl handle recursive searching much better.
- Bash was so slow that it required significantly reducing the size of the files in directories for testing (more than 10 times slower compared to Python and Perl).
