require "rails/generators/base"

module Everett
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root ::File.expand_path("../templates", __FILE__)

      def copy_initializer_file
        template "everett.rb", "config/initializers/everett.rb"
      end
    end
  end
end
