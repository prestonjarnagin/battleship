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
    #TODO You've already guessed this slot
    #TODO Try again

    guessed_slot.guess
    hit = enemy_board.ships.any? do |ship|
      ship.slots.include?(guessed_slot)
    end
    if hit
      hit_sequence(enemy_board)
    else
      p "Miss"
    end
  end

  def hit_sequence(enemy_board)
    sunk = enemy_board.ships.any? do |ship|
      ship.sunk?
    end
    p "#{@name} hit enemy ship"
    sink_sequence(enemy_board) if sunk
  end

  def sink_sequence(enemy_board)
    p "#{@name} sunk an enemy ship"
    endgame = enemy_board.ships.all? do |ship|
      ship.sunk?
    end
    trigger_endgame if endgame
  end

  def trigger_endgame
    @victory = true
  end

end
