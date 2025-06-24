#!/bin/bash

echo "Please, enter your name: "
read name
if [ -n "$name" ];
then 
echo "Congratulations! Your name $name is beautiful!"
else 
exit 2
fi
