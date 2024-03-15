module Avo
  module Cards
    class MetricCard < BaseCard
      class_attribute :prefix
      class_attribute :suffix
      class_attribute :format, default: -> {
        number_to_social value.to_i, start_at: 10_000
      }

      def formatted_result
        Avo::ExecutionContext.new(target: self.class.format, value: result_data, include: [ActionView::Helpers::NumberHelper, Avo::ApplicationHelper]).handle
      end
    end
  end
end
