require "everett/configuration"
require "everett/observer"
require "everett/subject"
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

    def enable
      configuration.instantiated_observers.each do |observer|
        observer
          .observed_classes
          .map { |klass| ::Everett::Subject[klass] }
          .each { |subject| subject.add_observer(observer) }
      end
    end
  end
end
