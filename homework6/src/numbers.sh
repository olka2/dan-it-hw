#!/usr/bin/env bash

secret=$(( RANDOM % 100 + 1 ))  
max_tries=5                  
try=1                  

while (( try <= max_tries )); do
  read -p "Спроба $try/$max_tries — вгадайте число (1-100): " guess

 
  if ! [[ $guess =~ ^[0-9]+$ ]]; then
    echo "Будь ласка, введіть ціле число."
    continue             
  fi

  if (( guess == secret )); then
    echo "Вітаємо! Ви вгадали правильне число."
    exit 0     
  elif (( guess < secret )); then
    echo "Занадто низько."
  else
    echo "Занадто високо."
  fi

  (( try++ )) 
done

echo "Вибачте, у вас закінчилися спроби. Правильним числом було $secret."
exit 1   