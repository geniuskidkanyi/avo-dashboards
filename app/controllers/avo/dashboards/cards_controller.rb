require_dependency "avo/application_controller"

module Avo
  module Dashboards
    class CardsController < Avo::ApplicationController
      before_action :set_parent
      before_action :fetch_cards
      before_action :set_card
      before_action :detect_chartkick

      def show
        render(:chartkick_missing) unless @chartkick_installed
      end

      private

      def set_parent
        @parent = if from_dashboard?
          dashboard_as_parent
        elsif from_resource?
          resource_as_parent
        end
      end

      def fetch_cards
        @parent.fetch_cards
      end

      def set_card
        @card = @parent.item_at_index(params[:index].to_i).tap do |card|
          if from_dashboard?
            card.hydrate(dashboard: @parent)
          elsif from_resource?
            card.hydrate(resource: @parent)
          end
        end
      end

      def detect_chartkick
        @chartkick_installed = if @card.class.ancestors.map(&:to_s).include?("Avo::Dashboards::ChartkickCard")
          defined?(Chartkick)
        else
          true
        end
      end

      def dashboard_as_parent
        @dashboard = Avo::Dashboards.dashboard_manager.get_dashboard_by_id params[:dashboard_id]
      end

      def resource_as_parent
        @resource = ::Avo.resource_manager.get_resource params[:resource_id]

        record = if params[:resource][:record_id].present?
          @resource.find_record(params[:resource][:record_id])
        end

        @resource.new(
          view: params[:resource][:view],
          params: params[:resource][:params],
          record: record
        ).detect_cards
      end

      def from_dashboard?
        @from_dashboard ||= params[:dashboard_id].present?
      end

      def from_resource?
        @from_resource ||= params[:resource_id].present?
      end
    end
  end
end
