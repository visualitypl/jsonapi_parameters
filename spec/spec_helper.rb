require 'bundler/setup'
Bundler.setup

require 'simplecov'
require 'simplecov-console'
SimpleCov.start do
  add_filter "spec/app/"
end

ENV["RAILS_ENV"] = "test"

require_relative "app/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("app/db/migrate", __dir__)]

require 'jsonapi_parameters'
require_relative './support/inputs_outputs_pairs'
require 'database_cleaner'
require 'factory_bot'
require 'hashdiff'


RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
