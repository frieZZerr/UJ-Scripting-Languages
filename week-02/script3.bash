#!/usr/bin/bash

# Arg check
if [ "$#" != 3 ]; then
  echo "Usage: operator number1 number2"
  exit 1
fi

# Operator check
operator=""
number1=""
number2=""
for arg in "$@"; do
  if [ "$arg" == "+" ] || [ "$arg" == "-" ] || [ "$arg" == "*" ] || [ "$arg" == "/" ] || [ "$arg" == "%" ] || [ "$arg" == "**" ]; then
    operator=$arg
    continue
  fi
  
  if [[ $number1 == "" ]]; then
    number1=$arg
  else
    number2=$arg
  fi
done

if [[ $operator == "" ]]; then
  echo "Invalid operator. Choose from +, -, \*, /, %, \**"
  exit 1
fi

# Number check
if ! [[ "$number1" =~ ^[1-9]$ ]] || ! [[ "$number2" =~ ^[1-9]$ ]]; then
  echo "Invalid numbers. Enter numbers from 1-9"
  exit 1
fi

gen_table() {
  if [[ $number1 > $number2 ]]; then
    min=$number2
    max=$number1
  else
    min=$number1
    max=$number2
  fi

  echo "Arithmetic Table:"
  for ((i = min; i <= max; i++)); do
    for ((j = min; j <= max; j++)); do
      printf "%-4d" $(( $i $operator $j ))
    done
    echo
  done
}

# Calculate and display result
gen_table
