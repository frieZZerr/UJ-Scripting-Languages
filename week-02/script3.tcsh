#!/usr/bin/tcsh

# Arg check
if ("$#" != 3) then
  echo "Usage: operator number1 number2"
  exit 1
endif

# Operator check
set operator=""
set number1=""
set number2=""

foreach arg ($argv)
  if ( "$arg" == "+" || "$arg" == "-" || "$arg" == "*" || "$arg" == "/" || "$arg" == "%" || "$arg" == "**" ) then
    set operator="$arg"
    continue
  endif

  if ("$number1" == "") then
    set number1="$arg"
  else
    set number2="$arg"
  endif
end

if ("$operator" == "") then
  echo "Invalid operator. Choose from +, -, \*, /, %, \**"
  exit 1
endif

# Number check
if ! (`expr "$number1" : '[1-9]*$'` || `expr "$number2" : '[1-9]*$'`) then
  echo "Invalid numbers. Enter numbers from 1-9"
  exit 1
endif

# Calculate and display result
if ("$number1" > "$number2") then
  set min="$number2"
  set max="$number1"
else
  set min="$number1"
  set max="$number2"
endif

echo "Arithmetic Table:"
set i=$min
while ($i <= $max)
  set j=$min
  while ($j <= $max)
    printf "%-4d" `expr $i $operator $j`
    @ j++
  end
  echo
  @ i++
end
