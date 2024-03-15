# frozen_string_literal: true

class Avo::CardsComponent < ViewComponent::Base
  def initialize(cards:, classes: nil)
    @cards = cards
    @classes = classes
  end

  def render?
    @cards.any?
  end
end
