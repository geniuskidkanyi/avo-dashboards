module Avo
  module Dashboards
    class Engine < ::Rails::Engine
      isolate_namespace Avo::Dashboards

      initializer "avo-dashboards.init" do
        if defined?(Avo)
          Avo.plugin_manager.register Avo::Dashboards::Plugin
        end
      end

      # TODO: make this production-ready
      config.app_middleware.use(
        Rack::Static,
        urls: ["/avo-dashboards-assets"],
        root: Avo::Dashboards::Engine.root.join("app", "assets", "builds")
      )
    end
  end
end
