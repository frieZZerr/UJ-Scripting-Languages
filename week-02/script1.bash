#!/usr/bin/bash

gen_table() {
    echo "Multiplications Table:"
    for ((i=1; i<=9; i++)); do
        for ((j=1; j<=9; j++)); do
            printf "%-3d " "$((i*j))"
        done
        echo
    done
}

gen_table
