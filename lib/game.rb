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
    entry = translate_cordinate(gets.chomp)
    while !entry
      p "Invalid cordinate"
      entry = translate_cordinate(gets.chomp)
    end
    @board.place_ship(cordinates)
  end

  def translate_cordinate(cordinate_string)
    if cordinate_string.length > 2
      return nil
    end
    y = cordinate_string[0].upcase.ord - 65
    x = cordinate_string[1].to_i - 1
    if y > @board.length || x > @board[0].length
      return nil
    end
    return [y,x]
  end

  def validate_ship_placement(cordinates)
    #Check if all cordinates are on board


    #Check if cordinates are next to each other vertically or horizontally
  end


end
