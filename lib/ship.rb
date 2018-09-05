class Ship

  attr_reader :slots

  def initialize(slots)
    @slots = slots
  end

  def sunk?
    @slots.all? do |slot|
      slot.guessed?
    end
  end
end
