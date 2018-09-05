require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/slot'
require './test/test_helper'

class ShipTest < Minitest::Test

  def setup
    @slot1 = Slot.new
    @slot2 = Slot.new
    @slot3 = Slot.new
    @slots = [@slot1, @slot2, @slot3]
    @ship = Ship.new(@slots)
  end

  def test_it_exists
    assert_instance_of Ship, @ship
  end

  def test_it_has_slots
    assert_equal @slots, @ship.slots
  end

  def test_it_knows_if_its_sunk
    @slot1.guess
    @slot2.guess
    @slot3.guess
    assert @ship.sunk?
  end

end
