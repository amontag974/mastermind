class Game
    @@turn = 1
    @@colors = ["R", "O", "Y", "G", "B", "P"]
    @@win = false

    attr_reader :key
    
    def initialize
        @key = create_key
    end

    def create_key
        color_key = []
        4.times { color_key << @@colors[rand(6)]}
        color_key
    end

    def guess_code
        guess = gets.chomp
        guess = guess.split(" ")
        guess
    end

    def valid_guess(guess)
        return false if !self.correct_length?(guess)
        guess.each do |i|
            return false if !@@colors.include?(i)
        end
        true
    end

    def correct_length?(guess)
        return true if guess.length == 4
        false
    end

    def correct_values?(guess)
        color_match = self.check_amount_of_each(guess)
        exact_match = self.check_exact_match(guess)
        decoder = "B" * exact_match  + "W" * (color_match - exact_match)
        decoder.ljust(4, '-')
    end

    def check_amount_of_each(guess)
        h1 = self.key_hash
        h2 = self.guess_hash(guess)
        count = 0 
        h2.each do |key,value| 
            if h2[key] > h1[key]
                count += h2[key] - h1[key]
            end
        end
        4 - count
    end

    def guess_hash(guess)
        create_hash(guess)
    end

    def key_hash
        create_hash(self.key)
    end

    def create_hash(guess)
        hash = Hash.new(0)
        guess.each do |i|
            hash[i] += 1
        end
        hash
    end

    def check_exact_match(guess)
        count = 0
        (0..3).each do |i|
            if self.key[i] == guess[i]
                count += 1
            end
        end
        count
    end

    def play_turn
        puts "Please enter a guess: "
        guess = self.guess_code
        while !self.valid_guess(guess)
            puts "Please enter a VALID guess (must contain exactly four of the following: R, O, Y, G, B, P)"
            guess = guess_code
        end
        decoder = correct_values?(guess)
        unless decoder == "BBBB"
            return decoder
        else
            @@win = true
            puts "You win!"
        end
    end

    def play_game
        puts "Welcome to Mastermind. Please pick four colors from the following\nwith spaces between them. Duplicates are allowed: R, O, Y, G, B, P: "
        while @@turn <13
            if @@win == true
                break
            else
                puts " "
                puts "Turn #{@@turn}"
                puts self.play_turn
                if @@turn > 12
                    puts "The game is over. You did not win"
                    puts "The correct key was #{self.key[0]} #{self.key[1]} #{self.key[2]} #{self.key[3]}"
                end
                @@turn += 1
            end
        end
    end
end

solution = Game.new
solution.play_game