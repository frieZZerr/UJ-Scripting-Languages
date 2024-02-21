#!/bin/bash

function grep_in_directory {
    local directory=$1
    local pattern=$2
    local count=0

    if [[ -d $directory ]]; then
        for file_path in "$directory"/*; do
            if [[ -f $file_path ]]; then
                while IFS= read -r line; do
                    if [[ $line =~ $pattern ]]; then
                        ((count++))
                    fi
                done < "$file_path"
            elif [[ -d $file_path ]]; then
                count=$((count + $(grep_in_directory "$file_path" "$pattern")))
            fi
        done
    else
        echo "Error: $directory is not a directory"
    fi

    echo $count
}

function main {
    declare -a directories
    current_pattern=""
    match_found=false

    while [[ $# -gt 0 ]]; do
        case $1 in
        -d)
            shift
            if [[ $# -gt 0 ]]; then
                directory="$1"
                directories+=("$directory")
            else
                echo "Error: Missing directory after -d"
                exit 1
            fi
            ;;
        *)
            if [[ -n $current_pattern ]]; then
                for directory in "${directories[@]}"; do
                    count=$(grep_in_directory "$directory" "$current_pattern")
                    if [[ $count -gt 0 ]]; then
                        match_found=true
                        echo "$directory: $count matches for '$current_pattern'"
                    fi
                done
            fi
            current_pattern="$1"
            ;;
        esac
        shift
    done

    if [[ -n $current_pattern ]]; then
        for directory in "${directories[@]}"; do
            count=$(grep_in_directory "$directory" "$current_pattern")
            if [[ $count -gt 0 ]]; then
                match_found=true
                echo "$directory: $count matches for '$current_pattern'"
            fi
        done
    fi

    if [[ $match_found == false ]]; then
        echo "No matches found."
    fi
}

main "$@"
