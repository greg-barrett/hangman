require 'pstore'
class Game
  def initialize
    set_difficulty
    @guess_array=[]
    set_play_word
    set_turns
    set_blanks_array
  end

  def set_difficulty
    puts "Choose a word length between 5 and 10"
    @difficulty=Integer(gets.chomp)
  end

  def set_play_word
    lines_array=File.readlines("word_list")
    loop do
      @play_word=lines_array.sample.chomp
      break if @play_word.length ==@difficulty
    end
  end

  def play_word
    @play_word
  end

  def set_turns
    @turns=(play_word.length*1.3).to_i
  end

  def turns
    @turns
  end

  def set_blanks_array
    @blanks_array=[]
    play_word.length.times {@blanks_array<<"_"}
  end

  def blanks_array
    @blanks_array
  end

  def blanks_string
    @blanks_string= @blanks_array.join("")
  end

  def blanks_string_spaces
    @blanks_string_spaces= @blanks_array.join(" ")
  end

  def guess
    puts "Enter a guess"
    @guess=gets.chomp
  end

  def guess_array
    @guess_array
  end

  def check_guess
    blanks_string
    @play_word.each_char.with_index do |letter, num|
      if letter == @guess
        @blanks_array[num]=@guess
        blanks_string
      end
    end
    @guess_array<<@guess
    @turns-=1
  end

  def win
    if  @turns > 1 && @play_word == @blanks_string
      puts "You won!"
      true
    else
      false
    end
  end

end

puts "load game?"
answer= gets.chomp
if answer == "yes"
  store = PStore.new("storagefile")
  games = []
  store.transaction do
    games = store[:game]
    games.each do |the_game|
         the_game.play_word
         the_game.turns
         the_game.blanks_string
         the_game.blanks_string_spaces
        puts "\n\n#{the_game.blanks_string_spaces}\n\n"
        puts "Previous Guesses\n#{the_game.guess_array}"
          while the_game.win == false
            the_game.guess
            the_game.check_guess
            puts "\n\n#{the_game.blanks_string_spaces}\n\n"
            puts "Previous Guesses\n#{the_game.guess_array}"
            puts "\n\nGuesses Remaining #{the_game.turns}\n\n"

            break if the_game.win == true
            break if the_game.turns <1

            puts"would you like to save the game"
            input=gets.chomp
              if input == "yes"
                store = PStore.new("storagefile")
                store.transaction do
                  store[:game] ||= Array.new
                  store[:game] << the_game
                end
              end
          end
    if the_game.turns< 0
      puts "Better luck next time"
    end
  end
end

else
the_game=Game.new
puts the_game.play_word
  while the_game.win == false
    the_game.guess
    the_game.check_guess
    puts "\n\n#{the_game.blanks_string_spaces}\n\n"
    puts "Previous Guesses\n#{the_game.guess_array}"
    puts "\n\nGuesses Remaining #{the_game.turns}\n\n"

    break if the_game.win == true
    break if the_game.turns <1
    puts"would you like to save the game"
    input=gets.chomp
    if input == "yes"
  store = PStore.new("storagefile")
  store.transaction do
  store[:game] ||= Array.new
  store[:game] << the_game
  end
  end

  end
  if the_game.turns== 0
    puts "Better luck next time"
  end
end
