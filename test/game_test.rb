# require 'minitest/autorun'
# require 'minitest/pride'
require './lib/game'
require './test/test_helper'

class GameTest < Minitest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_it_can_translate_a_cordinate
    expected = [0,0]
    actual = @game.translate_cordinate("A1")
    assert_equal expected, actual

    expected = [3,3]
    actual = @game.translate_cordinate("D4")
    assert_equal expected, actual

    expected = [3,3]
    actual = @game.translate_cordinate("d4")
    assert_equal expected, actual
  end

  def test_it_wont_translate_cordinate_out_of_bounds
    actual = @game.translate_cordinate("E4")
    refute actual
    actual = @game.translate_cordinate("A5")
    refute actual
  end

  def test_it_wont_translate_incorrectly_formatted_input
    actual = @game.translate_cordinate("E4A")
    refute actual
    actual = @game.translate_cordinate("Hello")
    refute actual
  end

  def test_it_can_validate_correct_ship_placement
    placement = [[0,0],[0,1],[0,2]]
    assert_equal true, @game.valid_ship_placement?(placement)
    placement = [[0,0],[0,1]]
    assert_equal true, @game.valid_ship_placement?(placement)
    placement = [[1,0],[1,1],[1,2]]
    assert_equal true, @game.valid_ship_placement?(placement)
    placement = [[2,1],[1,1]]
    assert_equal true, @game.valid_ship_placement?(placement)
    placement = [[3,3],[3,2]]
    assert_equal true, @game.valid_ship_placement?(placement)
  end

  def test_it_will_not_validate_incorret_ship_placement
    placement = [[0,0],[0,1],[0,3]]
    assert_equal false, @game.valid_ship_placement?(placement)
    placement = [[2,0],[0,1],[0,3]]
    assert_equal false, @game.valid_ship_placement?(placement)
    placement = [[1,1],[1,1]]
    assert_equal false, @game.valid_ship_placement?(placement)
    placement = [[3,3],[3,3]]
    assert_equal false, @game.valid_ship_placement?(placement)
    placement = [[3,0],[4,0],[5,0]]
    assert_equal false, @game.valid_ship_placement?(placement)
    placement = [[1,3],[1,4]]
    assert_equal false, @game.valid_ship_placement?(placement)
  end

  def test_can_setup_computer_player_board
    assert_equal 0, @game.computer.board.ships.count
    @game.computer_setup
    assert_equal 2, @game.computer.board.ships.count
  end

  def test_it_can_interpret_player_input
    args = @game.interpret_cordinate_string("a1 a2",2)
    expected = {y:0, x:0, vertical:false, length:2}
    assert_equal expected, args

    args = @game.interpret_cordinate_string("c3 b3 d3", 3)
    expected = {y:1, x:2, vertical:true, length:3}
    assert_equal expected, args
  end

  def test_it_can_test_if_ship_objects_overlap
    board = Board.new
    ship_1 = board.make_ship({y:0,x:0,vertical:true,length:2})
    ship_2 = board.make_ship({y:1,x:0,vertical:false,length:3})
    assert @game.ships_collide?(ship_1,ship_2)

    ship_2 = board.make_ship({y:1,x:1,vertical:false,length:3})
    refute @game.ships_collide?(ship_1,ship_2)

    ship_1 = board.make_ship({y:1,x:1,vertical:true,length:3})
    ship_2 = board.make_ship({y:2,x:1,vertical:true,length:2})
    assert @game.ships_collide?(ship_1,ship_2)
  end


end
