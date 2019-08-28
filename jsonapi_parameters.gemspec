$:.push File.expand_path('lib', __dir__)

require 'jsonapi_parameters/version'

Gem::Specification.new do |spec|
  spec.name        = 'jsonapi_parameters'
  spec.version     = JsonApi::Parameters::VERSION
  spec.authors     = ['Visuality', 'marahin']
  spec.email       = ['contact@visuality.pl', 'me@marahin.pl']
  spec.homepage    = 'https://github.com/visualitypl/jsonapi_parameters'
  spec.summary     = 'Translator for JSON:API compliant parameters'
  spec.description = 'JsonApi::Parameters allows you to easily translate JSON:API compliant parameters to a structure expected by Rails.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.required_ruby_version = '>= 2.3.0'

  spec.add_runtime_dependency 'activesupport', '>= 4.1.8'
  spec.add_runtime_dependency 'actionpack', '>= 4.1.8'
  spec.add_runtime_dependency 'nokogiri', '~> 1.10.4'

  spec.add_development_dependency 'json', '~> 2.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3.13'
  spec.add_development_dependency 'database_cleaner', '~> 1.7.0'
  spec.add_development_dependency 'rails', '>= 4.1.8'
  spec.add_development_dependency 'rspec', '~> 3.8.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.8.1'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rubocop', '~> 0.62.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.31.0'
  spec.add_development_dependency 'bundler-audit', '~> 0.6.0'
  spec.add_development_dependency 'fast_jsonapi', '~> 1.5'
  spec.add_development_dependency 'factory_bot', '~> 4.11.1'
  spec.add_development_dependency 'faker', '~> 1.9.1'
  spec.add_development_dependency 'hashdiff', '~> 0.3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
  spec.add_development_dependency 'simplecov-console', '~> 0.4.2'
end
