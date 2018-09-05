require 'minitest/autorun'
require 'minitest/pride'
require './lib/player'
require './test/test_helper'
require 'simplecov'
SimpleCov.start

class PlayerTest < Minitest::Test

  def setup
    @player = Player.new
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_can_take_a_shot
   refute @player.board.slots[0][0].guessed?
   @player.take_shot([0,0])
   assert @player.board.slots[0][0].guessed?
  end

end
