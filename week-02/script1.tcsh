#!/usr/bin/tcsh

echo "Multiplications Table:"
set i = 1
while ($i <= 9)
    set j = 1
    while ($j <= 9)
        printf "%-3d " `expr $i \* $j`
        @ j++
    end
    echo
    @ i++
end
