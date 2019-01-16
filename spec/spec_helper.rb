require 'bundler/setup'
Bundler.setup

ENV["RAILS_ENV"] = "test"

require_relative "app/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("app/db/migrate", __dir__)]

require 'jsonapi_parameters'
require 'factory_bot'

Dir[
  File.expand_path(
    File.join(
      File.dirname(__FILE__), 'support', '**', '*.rb'
    )
  )
].each {|f| require f}

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
