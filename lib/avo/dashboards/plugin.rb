module Avo
  module Dashboards
    class Plugin < Avo::Plugin
      class << self
        def boot
          Avo.asset_manager.add_javascript "/avo-dashboards-assets/avo_dashboards"
          Avo::BaseResource.include Avo::Cards::Concerns::HasCards
        end

        def init
        end
      end
    end
  end
end
