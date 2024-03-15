module Avo
  module Dashboards
    module Concerns
      module VisibleInDashboard
        extend ActiveSupport::Concern

        included do
          class_attribute :visible, default: true
        end

        def is_visible?
          return false if !authorized?

          ::Avo::ExecutionContext.new(target: visible, dashboard: self).handle
        end

        def is_hidden?
          !is_visible?
        end
      end
    end
  end
end
