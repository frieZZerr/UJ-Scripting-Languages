# Multiplication Table Scripts

## Script 1
The first pair of scripts prints a neatly formatted multiplication table from 1 to 9 and ignores all options and arguments.

## Script 2
The second pair of scripts prints a multiplication table from the first argument to the second argument. If there are fewer than two arguments (i.e., only one argument provided and it is numeric), it is treated as the upper limit (with the lower limit being 1). When no arguments are provided, it behaves like the first script, showing the multiplication table from 1 to 9. These scripts check if the arguments are numeric and in the correct order. If any of the first two arguments are non-numeric, it prints a friendly comment. If there are more than two arguments, the extra arguments are ignored. If the first two arguments are numeric, it prints the multiplication table. If the order is incorrect (the first argument is greater than the second), it prints the table from the smaller number to the larger one.

## Script 3
The third pair of scripts performs the same function as the second pair but for any valid arithmetic operation acceptable by the shell (such as +-*/% and exponentiation). It checks all three arguments: one must be a known operator, and the other two must be numbers. If any condition is not met, it exits with an appropriate error code (1 for incorrect numeric argument, 2 for missing valid operator). If the script finds these three arguments, it prints the table of that operation exactly in the order of arguments, potentially from larger to smaller if needed.
