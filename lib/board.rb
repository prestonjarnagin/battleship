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

  def generate_slots
    board = []
    i = 0
    while i < 4
      board << generate_row(4)
      i += 1
    end
    return board
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
    return slots
  end

  def all_ship_slots
    slots = []
    ships.each do |ship|
      ship.slots.each do |slot|
        slots << slot
      end
    end
    return slots
  end

  private
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
