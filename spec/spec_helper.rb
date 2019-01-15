require 'bundler/setup'
Bundler.setup

require 'jsonapi_parameters'
Dir[
  File.expand_path(
    File.join(
      File.dirname(__FILE__), 'support', '**', '*.rb'
    )
  )
].each {|f| require f}

RSpec.configure do |config|
end
