$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "everett/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "everett"
  s.version     = Everett::VERSION
  s.authors     = ["yasaichi"]
  s.email       = ["yasaichi@users.noreply.github.com"]
  s.homepage    = "https://github.com/yasaichi/everett"
  s.summary     = "Simple observer for Rails 5 ActiveRecord"
  s.description = "Everett is a simple observer for Rails 5 ActiveRecord."
  s.license     = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activerecord", "~> 5.0"
  s.add_dependency "railties", "~> 5.0"

  s.add_development_dependency "ammeter"
  s.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "pry-coolline"
  s.add_development_dependency "reek"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
