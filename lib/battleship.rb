require './lib/game'
require 'pry'

p "Welcome to BATTLESHIP"
selection = ""
while selection != 'p' || selection != 'q' || selection != 'r'
  p "Would you like to (p)lay, (r)ead the instructions, or (q)uit"
selection = gets.chomp
  if selection == 'q'
    break
  elsif selection == 'r'
    puts File.read('./instructions.txt')
  elsif selection == 'p'
    game = Game.new
    game.computer_setup
    game.player_setup

    while !game.player.victory || !game.computer.victory
      game.main_phase
    end

  end
end
