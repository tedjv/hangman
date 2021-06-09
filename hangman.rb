# frozen_string_literal: true

require 'yaml'

# Play a game of Hangman against the computer
class Game

    def initialize
        @secret_word = File.readlines("wordbank.txt").sample.downcase.chomp
        game_loop
    end

    def game_loop
        @guesses = 6
        welcome_message
        create_board
        store_correct_guesses
        ask_to_load_game

        until @guesses == 0
            display_board
            ask_to_save_game
            get_guess
            check_guess
            check_for_win
        end

        puts "The word was #{@secret_word}! Game over!"
    end

    def welcome_message
        puts "Welcome to Hangman! If you make 6 incorrect guesses, you will lose the game! Good luck."
    end

    def ask_to_load_game
        puts "Would you like to load your previous game? Enter: Yes / No"
        answer = gets.chomp.downcase

        if answer == "yes"
            load_game
        elsif answer != "no"
            puts "Invalid input"
            ask_to_load_game
        end
    end

    def load_game
        file = YAML.safe_load(File.read("output/saved_game.yaml"))
        @secret_word = file['secret_word']
        @board = file['board']
        @correct_guesses = file['correct_guesses']
        @guesses = file['guesses']
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
            @guesses -= 1
            puts "Incorrect! #{@guesses} guesses remaining!"
        end
    end

    def update_board
        @board = @secret_word.gsub(/[^"#{@correct_guesses}"]/, " _ ")
    end

    def record_guess
        @correct_guesses.append(@guess)
    end

    def check_for_win
        if @board.include?(" _ ") == false
            p @board
            puts "You correctly guessed the word! Game over!"
            exit
        end
    end

    def ask_to_save_game
        puts "Would you like to save the game? Enter: Yes / No"
        answer = gets.chomp.downcase

        if answer == "yes"
            save_game
        elsif answer != "no"
            puts "Invalid input"
            ask_to_save_game
        end
    end

    def save_game
        Dir.mkdir 'output' unless Dir.exist? 'output'
        @filename = "saved_game.yaml"
        File.open("output/#{@filename}", 'w') { |file| file.write save_to_yaml }
    end

    def save_to_yaml
        YAML.dump(
            'secret_word' => @secret_word,
            'board' => @board,
            'correct_guesses' => @correct_guesses,
            'guesses' => @guesses
        )
    end
end

Game.new