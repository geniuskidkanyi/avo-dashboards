module Avo
  module Dashboards
    class DashboardManager
      attr_accessor :dashboards

      class << self
        def build
          instance = new
          instance.init_dashboards
          instance
        end
      end

      alias_method :all, :dashboards

      def initialize
        @dashboards = []
      end

      def init_dashboards
        load_resources_namespace

        self.dashboards = Avo::Dashboards::BaseDashboard.descendants
          .select do |dashboard|
            dashboard != Avo::Dashboards::BaseDashboard
          end
          .map do |dashboard|
            dashboard.new
          end
          .uniq do |dashboard|
            dashboard.id
          end
      end

      def load_resources_namespace
        Rails.autoloaders.main.eager_load_namespace(Avo::Dashboards)
      end

      # Returns the Avo dashboard by id
      #
      # get_dashboard_by_id(:dashy) -> Dashy
      def get_dashboard_by_id(id)
        dashboards.find do |dashboard|
          dashboard.id == id
        end
      end

      # Returns the Avo dashboard by name
      #
      # get_dashboard_by_name(:dashy) -> Dashy
      def get_dashboard_by_name(name)
        dashboards.find do |dashboard|
          dashboard.name == name
        end
      end

      def dashboards_for_navigation(user = nil)
        get_available_dashboards(user).select do |dashboard|
          dashboard.is_visible?
        end
      end

      def get_available_dashboards(user = nil)
        dashboards.sort_by { |r| r.name }
      end
    end

    def self.dashboard_manager
      DashboardManager.build
    end
  end
end
