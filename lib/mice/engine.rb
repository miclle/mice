module Mice
  module Rails
    class Engine < ::Rails::Engine
      initializer "mice.assets.precompile" do |app|
        %w(stylesheets javascripts fonts images).each do |sub|
          app.config.assets.paths << root.join('assets', sub)
        end
        app.config.assets.precompile << %r(mice/fontawesome-webfont\.(?:eot|svg|ttf|woff)$)
      end
    end
  end
end
