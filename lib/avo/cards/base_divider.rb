module Avo
  module Cards
    class BaseDivider
      include Avo::Dashboards::Concerns::VisibleInDashboard

      attr_reader :dashboard
      attr_reader :label
      attr_reader :invisible
      attr_reader :index
      attr_reader :visible

      class_attribute :id

      def initialize(dashboard: nil, label: nil, invisible: false, index: nil, visible: true)
        @dashboard = dashboard
        @label = label
        @invisible = invisible
        @index = index
        @visible = visible
      end

      def is_divider?
        true
      end

      def is_card?
        false
      end

      def is_visible?
        ::Avo::ExecutionContext.new(target: visible, card: self, parent: dashboard).handle
      end
    end
  end
end
