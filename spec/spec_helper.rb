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
require 'database_cleaner'
require 'factory_bot'
require 'hashdiff'

Dir[
  File.expand_path(
    File.join(
      File.dirname(__FILE__), 'support', '**', '*.rb'
    )
  )
].each {|f| require f}

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
