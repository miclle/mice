require "mice/version"

module Mice
  class << self
    # Inspired by Kaminari
    def load!

      if defined?(::Rails)
        require 'mice/engine'
      end

    end

  end

end

Mice.load!