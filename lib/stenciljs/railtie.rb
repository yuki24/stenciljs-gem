require "rails/railtie"

module Stenciljs
  class Rails
    class Railtie < ::Rails::Railtie
      initializer :stenciljs, group: :all do |app|
        app.config.assets.paths += %w(public/components/build/)
      end

      rake_tasks do
        load "tasks/stencil.rake"
      end
    end
  end
end
