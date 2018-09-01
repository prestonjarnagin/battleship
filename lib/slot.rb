class Slot

  def initialize
    @guessed = false
  end

  def guess
    @guessed = true
  end

  def guessed?
    @guessed
  end

end
