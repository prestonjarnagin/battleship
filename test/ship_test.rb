require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/slots'

class ShipTest < Minitest::Test

  def setup
    slot1 = Slot.new
    slot2 = slot.new
    slot3 = slot.new
    @slots = [slot1, slot2, slot3]
    @ship = Ship.new(slots)
  end

  def test_it_exists
    assert_instance_of Ship, @ship
  end

  def test_it_has_length
    assert_equal 3, @ship.length
  end

  def test_it_has_slots
    assert_equal @slots, @ship.slots
  end

end
