require './lib/board'
require './lib/player'

class Game
    attr_reader :computer,
                :player

  def initialize
    @computer = Player.new("Computer")
    @player = Player.new("Player")
  end

  def main_phase

    while !@player.victory && !@computer.victory
      draw_board
      puts "Enter cordinates to take a shot"
      shot = gets.chomp
      shot = translate_cordinate(shot)
      while shot == nil
        puts "Cordinates invalid. Try again"
        shot = gets.chomp
        shot = translate_cordinate(shot)
      end
      @player.take_shot(shot, @computer.board)

      if !@player.victory
        shot = [rand(0..3),rand(0..3)]
        @computer.take_shot(shot, @player.board)
      end
    end

    if @player.victory
      draw_win
    else
      draw_loss
    end
  end

  def draw_board
    board = []
    generate_display_symbols(board)
    draw_image(board)
  end

  def computer_setup
      ship_3 = generate_and_validate_ship(3)
      ship_2 = generate_and_validate_ship(2)
      while ships_collide?(ship_2,ship_3)
        ship_2 = generate_and_validate_ship(2)
      end
      @computer.board.place_ship(ship_3)
      @computer.board.place_ship(ship_2)

    puts "I have laid out my ships on the grid."
  end

  def generate_and_validate_ship(length)
    ship_valid = false

    cordinates = []
    while !ship_valid
      cordinates = []
      i = 0
      y = rand(0..3)
      x = rand(0..3)
      vertical = [true, false].sample
      if vertical
        while i < length
          cordinates << [y+i,x]
          i += 1
        end
      else
        while i < length
          cordinates << [y,x+i]
          i += 1
        end
      end
      ship_valid = true if valid_ship_placement?(cordinates)
      args = {y:y,x:x,vertical:vertical,length:length}
    end
    return @computer.board.make_ship(args)
  end

  def player_setup

    puts "\n"
    puts "You now need to layout your two ships."
    puts "The first is two units long and the"
    puts "second is three units long."
    puts "The grid has A1 at the top left and D4 at the bottom right."

    collide = true
    while collide
      puts "Enter the squares for the two-unit ship:"
      ship_2_args = interpret_cordinate_string(gets.chomp, 2)
      while !ship_2_args
        puts "Entry invalid. Enter the squares for the two-unit ship:"
        ship_2_args = interpret_cordinate_string(gets.chomp, 2)
      end

      puts "Enter the squares for the three-unit ship:"
      ship_3_args = interpret_cordinate_string(gets.chomp, 3)
      while !ship_3_args
        puts "Entry invalid. Enter the squares for the three-unit ship:"
        ship_3_args = interpret_cordinate_string(gets.chomp, 3)
      end

      ship_2 = @player.board.make_ship(ship_2_args)
      ship_3 = @player.board.make_ship(ship_3_args)
      if ships_collide?(ship_2, ship_3)
        puts "You've placed your ships on top of one another"
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

  def valid_ship_placement?(cordinates)
    ship_length = cordinates.length

    if ship_hangs_off_grid?(cordinates) || cordinates_contain_duplicates?(cordinates)
      return false
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

  private

  def cordinates_contain_duplicates?(cordinates)
    cordinates.each do |cordinate|
      if !cordinates.one? { |c| c==cordinate }
        return true
      end
    end
    return false
  end

  def ship_hangs_off_grid?(cordinates)
    cordinates.each do |cordinate|
      if cordinate[0] > @player.board.slots.length - 1
        return true
      elsif cordinate[1] > @player.board.slots[0].length - 1
        return true
      end
    end
    return false
  end

  def generate_display_symbols(board)
    @computer.board.slots.each do |row|
      this_row = []
      row.each do |slot|

        if slot.guessed?
          if @computer.board.ships.any? {|ship| ship.slots.include?(slot)}
            this_row << " H "
          else
            this_row << " M "
          end
        else
          this_row << " . "
        end
      end
      board << this_row
    end
    return board
  end

  def draw_win
    puts "=+=+=+=+=+=+="
    puts "You've Won!"
    puts "=+=+=+=+=+=+="
  end

  def draw_loss
    puts "=+=+=+=+=+=+="
    puts "You've Lost"
    puts "=+=+=+=+=+=+="
  end

  def draw_image(board)
    puts "========="
    puts ".   1   2   3   4"
    puts "A " + board[0].join(" ")
    puts "B " + board[1].join(" ")
    puts "C " + board[2].join(" ")
    puts "D " + board[3].join(" ")
    puts "========="
    puts "\n"
  end


end
