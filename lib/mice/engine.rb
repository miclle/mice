module Mice
  module Rails
    class Engine < ::Rails::Engine
      initializer "mice.assets.precompile" do |app|
        app.config.assets.precompile << %r(mice/fontawesome-webfont.eot\.(?:eot|svg|ttf|woff)$)
      end
    end
  end
end
