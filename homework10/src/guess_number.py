import random

def get_user_choice():
    while True:
        try:
            user_input = int(input("Введіть число від 1 до 100: "))
            if 1 <= user_input <= 100:
                return user_input
            else:
                print("Будь ласка, введіть число в діапазоні 1-100.")
        except ValueError:
            print("Помилка! Потрібно ввести число.")

def play_game():
    computer_choice = random.randint(1, 100)
    attempts = 5
    
    for attempt in range(1, attempts + 1):
        user_choice = get_user_choice()
        
        if user_choice == computer_choice:
            print("Вітаємо! Ви вгадали правильне число!")
            return
        elif user_choice > computer_choice:
            print("Занадто високо!")
        else:
            print("Занадто низько!")
        
        print(f"Залишилось спроб: {attempts - attempt}")
    
    print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {computer_choice}.")

if __name__ == '__main__':
    play_game()
