## Generalized Word Count (wc) - Python vs Perl

This Python script mimics the functionality of `wc` written in Perl. We develop a monolithic script (in a single file) and test it similarly to the first Python script, comparing the performance between our two versions (Perl and Python) to determine which one is faster and by how much.

## Usage Example
```bash
python script1.py [options] file1.txt file2.txt ...
```

## Performance Test Results
The performance test was conducted using the Perl and the Python script. Both scripts were executed on several large files to compare their efficiency in processing a significant number of lines.

The test results demonstrate that:
- The average execution time of scripts without passing options shows that Perl performs much better when it comes to counting specific items from files.
- However, when passing options for additional counting of numbers, the difference in execution time significantly increases, demonstrating that the Perl script runs almost 8 times faster than Python.
