#!/usr/bin/python3

import sys
import re

args = []
files = []

for arg in sys.argv[1:]:
    if arg in ['-c', '-N', '-n', '-p']:
        args.append(arg)
    elif re.match(r'-[a-zA-Z]', arg):
        print(f'Invalid argument: {arg}, skipping...')
    else:
        files.append(arg)

params = set(args)

if {'-c', '-n'} <= params or {'-c', '-p'} <= params or {'-p', '-n'} <= params:
    print('Cannot use these arguments together.')
    sys.exit(1)

number_lines = '-c' in params
skip_comment_lines = '-N' in params
number_separately = '-p' in params

line_number = 0

def process_file(file):
    global line_number
    with open(file, 'r') as fh:
        print(f"Reading {file}:")

        file_line_number = 0
        for line in fh:
            if skip_comment_lines and line.strip().startswith('#'):
                continue

            if number_lines:
                line_number += 1
#                print(f"{line_number}: {line}", end='')
            elif number_separately:
                file_line_number += 1
#                print(f"{file_line_number}: {line}", end='')
#            else:
#                print(line, end='')

if files:
    for file in files:
        process_file(file)
else:
    print('Files were not specified.')
    sys.exit(1)

sys.exit(0)
