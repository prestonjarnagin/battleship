require './lib/board'
require 'pry'
class Player

  attr_reader :board,
              :victory

  def initialize(name)
    @board = Board.new
    @name = name
    @victory = false
  end

  def take_shot(cordinate, enemy_board)
    guessed_slot = enemy_board.slots[cordinate[0]][cordinate[1]]
    guessed_slot.guess
    hit = enemy_board.ships.any? do |ship|
      ship.slots.include?(guessed_slot)
    end
    if hit
      hit_sequence(enemy_board)
    else
      puts @name + ": Miss"
    end
  end

  def hit_sequence(enemy_board)
    sunk = enemy_board.ships.any? do |ship|
      ship.sunk?
    end
    puts "#{@name}: Hit!"
    sink_sequence(enemy_board) if sunk
  end

  def sink_sequence(enemy_board)
    puts "#{@name} sunk an enemy ship"
    endgame = enemy_board.ships.all? do |ship|
      ship.sunk?
    end

    if endgame
      trigger_endgame
    end
  end

  def trigger_endgame
    @victory = true
  end

end
