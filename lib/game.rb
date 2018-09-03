require './lib/board'
require 'pry'

class Game
    attr_reader :cpu_board,
                :player_board

  def initialize
    @cpu_board = Board.new
    @player_board = Board.new
    computer_setup
  end

  def computer_setup
    valid_3 = false
    valid_2 = false

    #Validate & place 3 long ship
    while !valid_3
      y = rand(0..3)
      x = rand(0..3)
      vertical = [true, false].sample
      if vertical
        cordinates = [y,x],[y+1,x],[y+2,x]
      else
        cordinates = [y,x],[y,x+1],[y,x+2]
      end
      valid_3 = valid_ship_placement?(cordinates)
    end
    @cpu_board.place_ship(y,x,vertical,3)

    #Validate and place 2 long ship
    while !valid_2
      y = rand(0..3)
      x = rand(0..3)
      vertical = [true, false].sample
      if vertical
        cordinates = [y,x],[y+1,x]
      else
        cordinates = [y,x],[y,x+1]
      end

      if valid_ship_placement?(cordinates)
        #Check ships arent overlapping
        cordinates.each do |cordinate|
          slot = @cpu_board.slots[cordinate[0]][cordinate[1]]
          if @cpu_board.ships[0].slots.include?(slot)
            valid_2 = true
          end
        end
      end
    end
    @cpu_board.place_ship(y,x,vertical,2)

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

    @board.place_ship(entry)
  end

  def translate_cordinate(cordinate_string)
    if cordinate_string.length > 2
      return nil
    end
    y = cordinate_string[0].upcase.ord - 65
    x = cordinate_string[1].to_i - 1
    if y >= @player_board.slots.length || x >= @player_board.slots[0].length
      return nil
    end
    return [y,x]
  end

  def valid_ship_placement?(cordinates)
    ship_length = cordinates.length

    #Check Duplicates
    cordinates.each do |cordinate|
      if !cordinates.one? { |c| c==cordinate }
        return false
      end
    end

    #Ship doesnt hang off grid
    cordinates.each do |cordinate|
      if cordinate[0] > @player_board.slots.length - 1
        return false
      elsif cordinate[1] > @player_board.slots[0].length - 1
        return false
      end
    end

    #Horizontal Case
    y = cordinates[0][0]
    if cordinates.all? { |cordinate| cordinate[0] == y}
      minmax = cordinates.minmax_by do |cordinate|
        cordinate[1]
      end
      if (minmax[1][1] - minmax[0][1]) < ship_length
        return true
      end
    end

    #Vertical Case
    x = cordinates[0][1]
    if cordinates.all? { |cordinate| cordinate[1] == x}
      minmax = cordinates.minmax_by do |cordinate|
        cordinate[0]
      end
      if (minmax[1][0] - minmax[0][0]) < ship_length
        return true
      end
    end
    return false
  end


end
