require "rails/generators/test_unit"

module TestUnit
  module Generators
    class ObserverGenerator < ::TestUnit::Generators::Base
      check_class_collision suffix: "ObserverTest"
      source_root ::File.expand_path("../templates", __FILE__)

      def create_test_file
        destination = ::File.join("test/unit", class_path, "#{file_name}_observer_test.rb")
        template "observer_test.rb.erb", destination
      end
    end
  end
end
