require "everett/configuration"
require "everett/utils"
require "everett/version"

module Everett
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= ::Everett::Configuration.instance
    end

    def configure
      yield(configuration) if block_given?
    end
  end
end
