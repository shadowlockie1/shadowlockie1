#!/bin/bash

states=('Hawaii' 'Nebraska' 'NewYork' 'California' 'Nevada')

for state in ${states[@]};
do
        if [ $state == 'Hawaii' ];
                then
                echo "Hawaii is the best ever!"
                else
                echo "Hawaii is not for me"
        fi
done

NUM=(0 1 2 3 4 5 6 7 8 9)

for num in ${NUM[@]};
do
        if [ $num = '3' ] || [ $num = '5' ] || [ $num = '7' ];
        then
                echo $num
        fi
done
