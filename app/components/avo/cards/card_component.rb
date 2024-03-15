# frozen_string_literal: true

class Avo::Cards::CardComponent < ViewComponent::Base
  attr_reader :card

  def initialize(card: nil)
    @card = card

    init_card
  end

  def render?
    card.present?
  end

  def init_card
    card.query if card.respond_to? :query
  end
end
