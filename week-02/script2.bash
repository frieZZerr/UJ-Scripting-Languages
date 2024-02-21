#!/usr/bin/bash

# Arg check
if [ "$#" == 0 ]; then
  min=1
  max=9
elif [ "$#" == 1 ]; then
  if [[ "$1" =~ ^[1-9]$ ]]; then
    min=1
    max=$1
  else
    echo "Bad argument. Enter number from 1-9"
    exit 1
  fi
elif [ "$#" != 1 ]; then
  if [[ "$1" =~ ^[1-9]$ && "$2" =~ ^[1-9]$ ]]; then
    if [[ "$1" > "$2" ]]; then
      max=$1
      min=$2
    else
      min=$1
      max=$2
    fi
  else
    echo "Bad arguments. Enter 2 numbers from 1-9"
    exit 1
  fi
fi

gen_table() {
    echo "Multiplications Table:"
    for ((i = min; i <= max; i++)); do
      for ((j = min; j <= max; j++)); do
        result=$((i * j))
        printf "%-4d" $result
      done
      echo
    done
}

gen_table
