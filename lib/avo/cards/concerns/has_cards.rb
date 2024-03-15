module Avo
  module Cards
    module Concerns
      module HasCards
        extend ActiveSupport::Concern

        included do
          class_attribute :card_index, default: 0
        end

        def detect_cards
          cards
          self
        end

        def cards
        end

        def card(klass, label: nil, description: nil, cols: nil, rows: nil, refresh_every: nil, arguments: {}, visible: nil)
          cards_holder << klass.new(
            parent: self,
            label: label,
            description: description,
            cols: cols,
            rows: rows,
            refresh_every: refresh_every,
            index: card_index,
            arguments: arguments,
            visible: visible
          )
          self.card_index += 1
        end

        def divider(**args)
          cards_holder << BaseDivider.new(dashboard: self, **args)
        end

        def item_at_index(index)
          cards_holder.find { |card| card.index == index }
        end

        def visible_cards
          cards_holder.filter { |card| card.is_visible? }
        end

        private

        def cards_holder
          @cards_holder ||= []
        end
      end
    end
  end
end
