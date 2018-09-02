require './lib/slot'

class Board

  attr_reader :slots

  def initialize
    @slots = generate_slots
  end

    def generate_slots(columns = 4, rows = 4)
      # Keep in mind this method will generate a grid that is accessed with
      # a [y][x] pattern, since the spec specifies lookup like "A1", where
      # "A" is the y cordinate
      board = []
      i = 0
      while i < rows
        board << generate_row(columns)
        i += 1
      end
      return board
    end

    def generate_row(length)
      i = 0
      row = []
      while i < length
        row << Slot.new
        i += 1
      end
      return row
    end


end
