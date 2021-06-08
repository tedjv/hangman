# Play a game of Hangman
class Game
    @@guesses = 6

    def initialize
        @secret_word = File.readlines("wordbank.txt").sample.downcase.chomp
        game_loop
    end

    def game_loop
        welcome_message
        create_board
        store_correct_guesses

        until @@guesses == 0
            display_board
            get_guess
            check_guess
            check_for_win
        end

        puts "The word was #{@secret_word}! Game over!"
    end

    def welcome_message
        puts "Welcome to Hangman! If you make 6 incorrect guesses, you will lose the game! Good luck."
    end

    def create_board
        @board = @secret_word.gsub(/[A-Za-z]/, "_ " )
    end

    def store_correct_guesses
        @correct_guesses = []
    end

    def display_board
        p @board
    end

    def get_guess
        puts "Please enter a letter: "
        @guess = gets.chomp.downcase

        if @guess.match?(/[A-Za-z]/) == false || @guess.length != 1
            puts "Invalid input"
            get_guess
        end
    end

    def check_guess
        if @secret_word.include?("#{@guess}")
            puts "Good guess!"
            record_guess
            update_board
        else
            @@guesses -= 1
            puts "Incorrect! #{@@guesses} guesses remaining!"
        end
    end

    def check_for_win
        if @board.include?(" _ ") == false
            p @board
            puts "You correctly guessed the word! Game over!"
            exit
        end
    end

    def update_board
        @board = @secret_word.gsub(/[^"#{@correct_guesses}"]/, " _ ")
    end

    def record_guess
        @correct_guesses.append(@guess)
    end
end

Game.new