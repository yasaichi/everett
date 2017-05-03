require "rails/generators/named_base"

module Rails
  module Generators
    class ObserverGenerator < ::Rails::Generators::NamedBase
      check_class_collision suffix: "Observer"
      source_root ::File.expand_path("../templates", __FILE__)

      def create_observer_file
        destination = ::File.join("app/models", class_path, "#{file_name}_observer.rb")
        template "observer.rb.erb", destination
      end

      hook_for :test_framework
    end
  end
end
