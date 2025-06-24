#!/bin/bash

read -p "Please, enter your sentence: " sentence

echo "$sentence" | tr ' ' '\n' | tac | xargs