require "everett/utils"
require "singleton"

module Everett
  class Configuration
    include ::Singleton
    include ::Everett::Utils

    attr_reader :observers

    def initialize
      @observers = []
    end

    def instantiated_observers
      @observers.map { |observer| instantiate_observer(observer) }
    end

    def observers=(observers)
      @observers = Array(observers)
    end

    def reset
      @observers.clear
    end

    private

    def instantiate_observer(observer)
      constant = constantize(observer)
      return constant.instance if constant.respond_to?(:instance)

      raise ::TypeError,
        "#{constant} must be a lowercase, underscored class name " +
        "(or the class itself) responding to the method :instance."
    end
  end
end
