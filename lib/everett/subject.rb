require "active_record"
require "set"

module Everett
  class Subject
    CALLBACKS = ::Set[
      *::ActiveRecord::Callbacks::CALLBACKS.map(&:to_sym),
      *%i(create update destroy).map { |fire_on| :"after_#{fire_on}_commit" }
    ].freeze

    class << self
      private :new

      def [](model)
        instances.fetch(model) { |key| instances[key] = new(model) }
      end

      private

      def instances
        @instances ||= {}
      end
    end

    def initialize(model)
      @model = model
      @observers = ::Set.new
    end

    def add_observer(observer)
      return false if @observers.include?(observer)

      callbacks = CALLBACKS.select { |callback| observer.respond_to?(callback) }
      return false if callbacks.empty?

      # TODO: Rewrite the following line in the form of passing an observer to callbacks
      # if after_{create,update,destroy}_commit comes to call an identically named method
      # of a callback object (currently it always calls #after_commit).
      callbacks.each { |callback| @model.public_send(callback) { observer.public_send(callback, self) } }
      !!@observers.add(observer)
    end
  end
end
