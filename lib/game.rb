require './lib/board'

class Game

  def initialize
    @board = Board.new
    computer_setup
    user_setup
  end

  def computer_setup
    #TODO Validate ship placement
    y = rand(0..3)
    x = rand(0..3)
    vertical = [true, false].sample
    @board.place_ship(y,x,vertical,3)

    
    y = rand.(0..3)
    x = rand(0..3)
    vertical = [true, false].sample
    @board.place_ship(y,x,vertical,2)
    p "I have laid out my ships on the grid."
  end

  def user_setup
    p "Enter the squares for the two-unit ship:
    You now need to layout your two ships.
    The first is two units long and the
    second is three units long.
    The grid has A1 at the top left and D4 at the bottom right."
    @board.place_ship(cordinates)
  end


end
