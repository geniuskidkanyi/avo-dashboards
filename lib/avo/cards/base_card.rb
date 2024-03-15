module Avo
  module Cards
    class BaseCard
      include Avo::Dashboards::Engine.routes.url_helpers
      include Avo::Dashboards::Concerns::VisibleInDashboard
      include Avo::Concerns::HasDescription

      class_attribute :id
      class_attribute :label
      class_attribute :cols, default: 1
      class_attribute :rows, default: 1
      class_attribute :initial_range
      class_attribute :ranges, default: []
      class_attribute :refresh_every
      class_attribute :display_header, default: true
      # private
      class_attribute :result_data

      attr_accessor :dashboard
      attr_accessor :resource
      attr_accessor :arguments
      attr_accessor :index

      delegate :resource_card_path, to: "Avo::Engine.routes.url_helpers"

      def initialize(parent:, arguments: {}, index: 0, cols: nil, rows: nil, label: nil, description: nil, refresh_every: nil, visible: nil)
        if parent.class.ancestors.include? Avo::BaseResource
          @resource = parent
          @card_path = :resource_card_path
          @parent_path_id = @resource.class
        else
          @dashboard = parent
          @card_path = :dashboard_card_path
          @parent_path_id = @dashboard.id
        end
        @arguments = arguments
        @index = index
        @cols = cols
        @rows = rows
        @label = label
        @refresh_every = refresh_every
        @description = description
        @visible = visible
      end

      def label
        return @label.to_s if @label.present?
        return self.class.label.to_s if self.class.label.present?

        self.class.id.to_s.humanize
      end

      def refresh_every
        @refresh_every || self.class.refresh_every
      end

      def turbo_frame
        "#{parent.id}_#{id}"
      end

      def frame_url(enforced_range: initial_range || ranges.first, params: {})
        params = if params.respond_to?(:permit!)
          params.permit!
        else
          {}
        end

        send(@card_path,
          @parent_path_id,
          id,
          turbo_frame: turbo_frame,
          index: index,
          range: enforced_range,
          resource: {
            view: @resource&.view,
            record_id: @resource&.record,
            params: @resource&.params
          }.compact,
          **params.to_h.symbolize_keys # we want tp pass all the params to
        )
      end

      def card_classes
        result = ""

        # Writing down the classes so TailwindCSS knows not to purge them
        classes_for_cols = {
          1 => " sm:col-span-1",
          2 => " sm:col-span-2",
          3 => " sm:col-span-3",
          4 => " sm:col-span-4",
          5 => " sm:col-span-5",
          6 => " sm:col-span-6"
        }

        classes_for_rows = {
          1 => " min-h-[8rem] row-span-1",
          2 => " min-h-[16rem] row-span-2",
          3 => " min-h-[24rem] row-span-3",
          4 => " min-h-[32rem] row-span-4",
          5 => " min-h-[40rem] row-span-5",
          6 => " min-h-[48rem] row-span-6"
        }

        result += classes_for_cols[cols.to_i] if classes_for_cols[cols.to_i].present?
        result += classes_for_rows[rows.to_i] if classes_for_rows[rows.to_i].present?

        result
      end

      def type
        return :metric if is_a?(MetricCard)
        return :chartkick if is_a?(ChartkickCard)
        return :partial if is_a?(PartialCard)
      end

      def hydrate(**args)
        args.each do |key, value|
          send("#{key}=", value)
        end

        self
      end

      def range
        return params[:range] if params.dig(:range).present?

        return initial_range if initial_range.present?

        ranges.first
      end

      def result(data)
        self.result_data = data

        self
      end

      def is_card?
        true
      end

      def is_divider?
        false
      end

      def context
        ::Avo::Current.context
      end

      def current_user
        ::Avo::Current.user
      end

      def view_context
        ::Avo::Current.view_context
      end

      def params
        ::Avo::Current.params
      end

      def request
        ::Avo::Current.request
      end

      def visible
        @visible || self.class.visible
      end

      def is_visible?
        ::Avo::ExecutionContext.new(target: visible, card: self, resource: resource, dashboard: dashboard).handle
      end

      def parent
        @resource || @dashboard
      end

      private

      def cols
        @cols || self.class.cols
      end

      def rows
        @rows || self.class.rows
      end

      def description_attributes
        {
          dashboard: dashboard,
          resource: resource,
          parent: parent,
          arguments: arguments,
          params: params,
        }
      end
    end
  end
end
