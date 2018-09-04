require './lib/board'
require 'pry'
require './lib/player'

class Game
    attr_reader :computer,
                :player

  def initialize
    @computer = Player.new("Computer")
    @player = Player.new("Player")
  end

  def main_phase
    draw_board
    p "Enter cordinates to take a shot"
    shot = gets.chomp
    shot = translate_cordinate(shot)
    while shot == nil
      p "Cordinates invalid. Try again"
      shot = gets.chomp
      shot = translate_cordinate(shot)
    end
    @player.take_shot(shot, @computer.board)

    if !@player.victory
      shot = [rand(0..3),rand(0..3)]
      @computer.take_shot(shot, @player.board)
    end
  end

  def draw_board
    board = []

    index = 0
    while index < 4
      this_row = []

      @computer.board.slots[index].each do |slot|
        if slot.guessed? && @computer.board.all_ship_slots.include?(slot)
          this_row << " H "
        elsif slot.guessed?
          this_row << " M "
        else
          this_row << " . "
        end
        board << this_row
      end
      index += 1

    end

    p "========="
    p ".   1   2   3   4"
    p "A " + board[0].join(" ")
    p "B " + board[1].join(" ")
    p "C " + board[2].join(" ")
    p "D " + board[3].join(" ")
    p "========="

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
    args = {y:y,x:x,vertical:vertical,length:3}
    ship = @computer.board.make_ship(args)
    @computer.board.place_ship(ship)

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
          slot = @computer.board.slots[cordinate[0]][cordinate[1]]
          if @computer.board.ships[0].slots.include?(slot)
            valid_2 = true
          end
        end
      end
    end
    args = {y:y,x:x,vertical:vertical,length:2}
    ship = @computer.board.make_ship(args)
    @computer.board.place_ship(ship)
    p "I have laid out my ships on the grid."

  end

  def player_setup

    p "You now need to layout your two ships."
    p "The first is two units long and the"
    p "second is three units long."
    p "The grid has A1 at the top left and D4 at the bottom right."

    collide = true
    while collide
      p "Enter the squares for the two-unit ship:"
      ship_2_args = interpret_cordinate_string(gets.chomp, 2)
      while !ship_2_args
        p "Entry invalid. Enter the squares for the two-unit ship:"
        ship_2_args = interpret_cordinate_string(gets.chomp, 2)
      end
      p "Enter the squares for the three-unit ship:"
      ship_3_args = interpret_cordinate_string(gets.chomp, 3)
      while !ship_3_args
        p "Entry invalid. Enter the squares for the three-unit ship:"
        ship_3_args = interpret_cordinate_string(gets.chomp, 3)
      end
      ship_2 = @player.board.make_ship(ship_2_args)
      ship_3 = @player.board.make_ship(ship_3_args)
      if ships_collide?(ship_2, ship_3)
        p "You've placed your ships on top of one another"
      else
        collide = false
      end
    end
    @player.board.place_ship(ship_2)
    @player.board.place_ship(ship_3)
  end



  def ships_collide?(ship_1, ship_2)
    ship_1.slots.any? { |slot| ship_2.slots.include?(slot)}
  end


  def interpret_cordinate_string(input, expected_length)
    #Return a hash of args to build a ship, or nil if
    #input is invalid
    input = input.split
    if input.length != expected_length
      return nil
    end
    input.map! { |cordinate| translate_cordinate(cordinate)}
    if !valid_ship_placement?(input)
      return nil
    end
    if input[0][0] == input[1][0]
      vertical = false
      min = input.min_by { |cordinate| cordinate[1]}
      x = min[1]
      y = min[0]
    else
      vertical = true
      min = input.min_by { |cordinate| cordinate[0]}
      x = min[1]
      y = min[0]
    end
    args = {
      x: x,
      y: y,
      vertical: vertical,
      length: expected_length}
    return args
  end

  def translate_cordinate(cordinate_string)
    if cordinate_string.length > 2
      return nil
    end
    y = cordinate_string[0].upcase.ord - 65
    x = cordinate_string[1].to_i - 1
    if y >= @player.board.slots.length || x >= @player.board.slots[0].length
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
      if cordinate[0] > @player.board.slots.length - 1
        return false
      elsif cordinate[1] > @player.board.slots[0].length - 1
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
