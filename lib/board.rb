require './lib/slot'
require './lib/ship'
require 'pry'

class Board

  attr_reader :slots,
              :ships

  def initialize
    @slots = generate_slots
    @ships = []
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

  def make_ship(args)
    slots = []
    if args[:vertical]
      i = 0
      while i < (args[:length])
        slots << @slots[args[:y]+i][args[:x]]
        i += 1
      end
    else
      i = 0
      while i < (args[:length])
        slots << @slots[args[:y]][args[:x]+i]
        i += 1
      end
    end
    return Ship.new(slots)
  end

  def place_ship(ship)
    @ships << ship
  end

  def continuous_slots
    i = 0
    slots = []
    while i < @slots.length
      @slots[i].each do |slot|
        slots << slot
      end
      i += 1
    end
    slots
  end

end
