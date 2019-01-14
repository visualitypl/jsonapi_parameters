$:.push File.expand_path("lib", __dir__)

require "jsonapi_parameters/version"

Gem::Specification.new do |spec|
  spec.name        = "jsonapi_parameters"
  spec.version     = JsonApiParameters::VERSION
  spec.authors     = ["marahin"]
  spec.email       = ["me@marahin.pl"]
  spec.homepage    = "https://github.com/visualitypl/jsonapi_parameters"
  spec.summary     = "Translator for JSON:API compliant parameters"
  spec.description = "JsonApi::Parameters allows you to easily translate JSON:API compliant parameters to a structure expected by Rails."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_development_dependency "sqlite3"
end
