class Alphabet:
    def __init__(self, lang, letters):
        self.lang = lang
        self.letters = letters

    def print(self):
        print(" ".join(self.letters))

    def letters_num(self):
        return len(self.letters)


class EngAlphabet(Alphabet):
    _letters_num = 26

    def __init__(self):
        super().__init__("En", list("ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

    def is_en_letter(self, letter):
        return letter.upper() in self.letters

    def letters_num(self):
        return EngAlphabet._letters_num

    @staticmethod
    def example():
        return "Hello! This is my python code :)"


if __name__ == "__main__":
    eng = EngAlphabet()

    print("Alphabet:")
    eng.print()

    print("Number of letters:", eng.letters_num())

    print("If the letter 'F' belongs to the English alphabet?", eng.is_en_letter("F"))
    print("If the letter 'Щ' belongs to the English alphabet?", eng.is_en_letter("Щ"))

    print("Example:", EngAlphabet.example())
