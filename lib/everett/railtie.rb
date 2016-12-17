require "rails/railtie"

module Everett
  class Railtie < ::Rails::Railtie
    config.after_initialize do
      ::Everett.enable
    end
  end
end
