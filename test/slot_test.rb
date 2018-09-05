require 'minitest/autorun'
require 'minitest/pride'
require './lib/slot'
require './test/test_helper'

class SlotTest < Minitest::Test

  def setup
    @slot = Slot.new
  end

  def test_it_exists
    assert_instance_of Slot, @slot
  end

  def test_it_is_not_guessed_by_default
    refute @slot.guessed?
  end

  def test_it_can_be_guessed
    @slot.guess
    assert @slot.guessed?
  end
end
