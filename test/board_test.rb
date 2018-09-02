require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_a_grid_of_slots
    @board.slots.each do |column|
      column.each do |item|
        assert_instance_of Slot, item
      end
    end
  end

  def test_its_grid_defaults_to_4x4
    assert_instance_of Slot, @board.slots[3][3]
    refute @board.slots[4]
    refute @board.slots[3][4]
  end

  def test_it_can_place_a_ship
    @board.place_ship([0,0], 'v', 3)
  end

end
