require "active_support"
require "active_support/inflector"
require "everett/utils"
require "set"
require "singleton"

module Everett
  class Observer
    include ::Singleton
    include ::Everett::Utils

    class << self
      private

      def observe(*models)
        instance.observe(*models)
      end
    end

    def initialize
      @observed_classes = ::Set.new
    end

    def observe(*models)
      models.map! { |model| constantize(model) }.compact!
      !!@observed_classes.merge(models)
    end

    def observed_classes
      @observed_classes.empty? ? Array(default_class) : @observed_classes.to_a
    end

    private

    def default_class
      md = /\A(?<class_name>.*)Observer\z/.match(self.class.name)
      md[:class_name].constantize if md
    rescue ::NameError
      nil
    end
  end
end
