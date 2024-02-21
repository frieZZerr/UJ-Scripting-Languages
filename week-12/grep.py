#!/usr/bin/env python3

import os
import sys

def grep_in_directory(directory, pattern):
    count = 0
    try:
        for root, dirs, files in os.walk(directory):
            for file in files:
                file_path = os.path.join(root, file)
                with open(file_path, 'r', errors='ignore') as f:
                    for line in f:
                        if pattern in line:
                            count += 1
    except Exception as e:
        print(f"Error processing directory {directory}: {e}")
    
    return count

def main():
    directories = []
    current_pattern = None

    i = 1
    while i < len(sys.argv):
        if sys.argv[i] == "-d":
            i += 1
            if i < len(sys.argv):
                directory = sys.argv[i]
                directories.append(directory)
                current_pattern = None
            else:
                print("Error: Missing directory after -d")
                sys.exit(1)
        else:
            current_pattern = sys.argv[i]
            for directory in directories:
                count = grep_in_directory(directory, current_pattern)
                print(f"{directory}: {count} matches for '{current_pattern}'")
        i += 1

if __name__ == "__main__":
    main()
