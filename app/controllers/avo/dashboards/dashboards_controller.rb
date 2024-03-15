require_dependency "avo/application_controller"

module Avo
  module Dashboards
    class DashboardsController < Avo::ApplicationController
      before_action :set_dashboard, only: :show
      before_action :fetch_cards, only: :show
      before_action :authorize!, only: :show

      def show
        @page_title = @dashboard.name
      end

      private

      def set_dashboard
        @dashboard = Avo::Dashboards.dashboard_manager.get_dashboard_by_id params[:id]

        raise ActionController::RoutingError.new("Not Found") if @dashboard.nil?
      end

      def authorize!
        raise Avo::NotAuthorizedError.new if !@dashboard.authorized?
      end

      def fetch_cards
        @dashboard.fetch_cards
      end
    end
  end
end
