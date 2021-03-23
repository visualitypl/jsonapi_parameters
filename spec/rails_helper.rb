require 'spec_helper'
require 'rails'
require 'rspec/rails'
require 'json'

load "#{Rails.root}/db/schema.rb"

def jsonapi_response
  JSON.parse(response.body, symbolize_names: true)
end

def post_with_rails_fix(url, params: {}, **others)
  if Rails::VERSION::MAJOR >= 5
    post url, params: params, **others
  else
    post url, params, **others
  end
end

def patch_with_rails_fix(url, params: {}, **others)
  if Rails::VERSION::MAJOR >= 5
    patch url, params: params, **others
  else
    patch url, params, **others
  end
end
