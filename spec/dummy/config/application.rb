require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"

Bundler.require(*Rails.groups)
require "everett"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

