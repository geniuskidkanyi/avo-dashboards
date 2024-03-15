module Avo
  module Dashboards
    class BaseDashboard
      # TODO: convert the dashboards from classes to instances.
      include Avo::Dashboards::Concerns::VisibleInDashboard
      include Avo::Cards::Concerns::HasCards
      include Avo::Concerns::HasDescription
      include Avo::Dashboards::Engine.routes.url_helpers
      extend ActiveSupport::DescendantsTracker

      class_attribute :id
      class_attribute :name
      class_attribute :grid_cols, default: 3
      # TODO: remove this when you make the conversion.
      class_attribute :visible, default: true
      class_attribute :authorize, default: -> { true }

      class << self
        def deprecated_dsl_api(name = nil)
          message = "This API was deprecated. Please use `#{name}` inside the `cards` method."
          raise Avo::DeprecatedAPIError.new message
        end

        # DSL methods
        # def card def divider
        [:card, :divider].each do |method|
          define_method method do |*args, &block|
            deprecated_dsl_api method
          end
        end
        # END DSL methods
      end

      def fetch_cards
        cards
      end

      def classes
        case grid_cols
        when 3
          "sm:grid-cols-3"
        when 4
          "sm:grid-cols-4"
        when 5
          "sm:grid-cols-5"
        when 6
          "sm:grid-cols-6"
        else
          "sm:grid-cols-3"
        end
      end

      def navigation_label
        name
      end

      def authorized?
        Avo::ExecutionContext.new(target: authorize, dashboard: self).handle
      end

      def to_param
        id
      end
    end
  end
end
