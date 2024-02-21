#!/usr/bin/python

import re
import sys
import os

count_integers = False
count_numbers = False
exclude_lines = False
files = []

# Check args
while len(sys.argv) > 1:
    arg = sys.argv.pop(1)

    if arg == '-i':
        count_integers = True
    elif arg == '-d':
        count_numbers = True
    elif arg == '-e':
        exclude_lines = True
    elif arg.startswith('-'):
        sys.exit(f"Invalid option: {arg}\n")
    elif os.path.isfile(arg):
        files.append(arg)
    else:
        sys.exit(f"Invalid option or file: {arg}\n")

# Check for files
if not files:
    sys.exit("Usage: python script.py [-i|-d] [-e] FILE1 FILE2 ...\n")

total_lines, total_words, total_chars, total_integers, total_numbers = 0, 0, 0, 0, 0

def process_line(line):
    global local_lines, local_words, local_chars, local_integers, local_numbers

    local_lines += 1

    if exclude_lines and line.strip().startswith('#'):
        return

    words = re.findall(r'\S+', line)
    local_words += len(words)
    local_chars += len(line)

    if count_integers:
        local_integers += len(re.findall(r'(?<!\.)(?<!e-)(?<!E-)(?<!d-)(?<!D-)(?<!\^)\b[0-9]+\b(?!\.)(?!\^)', line))

    if count_numbers:
        local_numbers += len(re.findall(r'(?<!\.)(?<!e-)(?<!E-)(?<!d-)(?<!D-)(?<!\^)\b[0-9]+\b(?!\.)(?!\^)|'
                                        r'(?<!q)(?<!Q)[0-9]+(\.)[0-9]+|'
                                        r'[0-9]+(e-?)[0-9]+|'
                                        r'[0-9]+(E-?)[0-9]+|'
                                        r'(q)(?<!Q)[0-9]+(\.)[0-9]+|'
                                        r'[0-9]+(\^-?)[0-9]+|'
                                        r'[0-9]+(d-?)[0-9]+|'
                                        r'[0-9]+(D-?)[0-9]+', line))

# Process files
for file in files:
    local_lines, local_words, local_chars, local_integers, local_numbers = 0, 0, 0, 0, 0

    with open(file, 'r') as f:
        for line in f:
            process_line(line)

    total_lines += local_lines
    total_words += local_words
    total_chars += local_chars
    total_integers += local_integers
    total_numbers += local_numbers

    summary = f"{local_lines} {local_words} {local_chars} "
    if count_integers:
        summary += f"{local_integers} "
    if count_numbers:
        summary += f"{local_numbers} "
    summary += f"{file}"
    print(summary)

if len(files) > 1:
    summary = f"{total_lines} {total_words} {total_chars} "
    if count_integers:
        summary += f"{total_integers} "
    if count_numbers:
        summary += f"{total_numbers} "
    summary += "total"
    print(summary)
