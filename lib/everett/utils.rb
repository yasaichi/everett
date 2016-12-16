require "active_support"
require "active_support/inflector"

module Everett
  module Utils
    module_function

    def constantize(underscored_name_or_constant)
      underscored_name_or_constant.respond_to?(:to_sym) ?
        underscored_name_or_constant.to_s.camelize.constantize :
        underscored_name_or_constant
    end
  end
end
