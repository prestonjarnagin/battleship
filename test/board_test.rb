require 'minitest/autorun'
require 'minitest/pride'
require './lib/board'
require './test/test_helper'
require 'simplecov'
SimpleCov.start

class BoardTest < Minitest::Test

  def setup
    @board = Board.new
  end

  def test_it_exists
    assert_instance_of Board, @board
  end


  def test_it_initializes_with_a_grid_of_slots_objects
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

  def test_it_can_create_a_ship
    args = {x:0,y:0,vertical:true,length:3}
    ship = @board.make_ship(args)
    assert_instance_of Ship, ship
    assert_instance_of Slot, ship.slots[0]
    assert_instance_of Slot, ship.slots[1]
    assert_instance_of Slot, ship.slots[2]

    args = {x:2,y:2,vertical:true,length:2}
    ship = @board.make_ship(args)
    assert_instance_of Slot, ship.slots[0]
    assert_instance_of Slot, ship.slots[1]
  end

  def test_created_ships_contain_unique_slots
    args = {x:0,y:0,vertical:true,length:3}
    ship = @board.make_ship(args)
    refute ship.slots[0] == ship.slots[1]
    refute ship.slots[1] == ship.slots[2]
  end

  def test_it_can_save_created_ships
    args = {x:0,y:0,vertical:true,length:3}
    ship = @board.make_ship(args)
    @board.place_ship(ship)
    assert_equal 1, @board.ships.length
  end

  def test_it_can_return_continuous_slots
    assert_equal 16, @board.continuous_slots.length
    assert_equal @board.slots[0][0], @board.continuous_slots[0]
  end

end
