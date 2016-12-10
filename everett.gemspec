$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "everett/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "everett"
  s.version     = Everett::VERSION
  s.authors     = ["yasaichi"]
  s.email       = ["yasaichi@users.noreply.github.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Everett."
  s.description = "TODO: Description of Everett."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"

  s.add_development_dependency "sqlite3"
end
