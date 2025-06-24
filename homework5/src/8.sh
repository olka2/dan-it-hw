#!/bin/bash

fruits=("apple" "pineapple" "cherry" "pear" "coconut" "orange")

for i in ${fruits[@]};
do
    echo $i
    sleep 0.5
done