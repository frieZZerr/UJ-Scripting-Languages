#!/usr/bin/tcsh

set min=1
set max=9

# Arg check
if ($# == 1) then
  if (`expr "$1" : '[0-9]*$'`) then
    set min=1
    set max=$1
  else
    echo "Bad argument. Enter number from 1-9"
    exit 1
  endif
endif
if ($# > 1) then
  if (`expr "$1" : '[0-9]*$'` && `expr "$2" : '[0-9]*$'`) then
    if ("$1" > "$2") then
      set max=$1
      set min=$2
    else
      set min=$1
      set max=$2
    endif
  else
    echo "Bad arguments. Enter 2 numbers from 1-9"
    exit 1
  endif
endif

echo "Multiplications Table:"
set i=$min
while ($i <= $max)
  set j=$min
  while ($j <= $max)
    printf "%-4d" `expr $i \* $j`
    @ j++
  end
  echo
  @ i++
end
