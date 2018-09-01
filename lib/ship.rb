class Ship

  attr_reader :slots

  def initialize(slots)
    @slots = slots
  end

  def length
    @slots.length
  end

end
