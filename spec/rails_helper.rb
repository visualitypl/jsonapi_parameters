require 'spec_helper'
require 'rails'
require 'rspec/rails'
require 'json'

load "#{Rails.root}/db/schema.rb"

def jsonapi_response
  JSON.parse(response.body, symbolize_names: true)
end
