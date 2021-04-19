require 'spec_helper'
require 'rails'
require 'rspec/rails'
require 'json'

load "#{Rails.root}/db/schema.rb"

def jsonapi_response
  JSON.parse(response.body, symbolize_names: true)
end

# rails changed controller params from positional to keywords in rails 5.1.7
# 5.1.6>= rails >=5.0 consumes both ways.
# https://apidock.com/rails/v5.1.7/ActionController/TestCase/Behavior/process
# others keywords can be: session, body, flash, format, xhr, as.
# We are using `as: json` in specs (rails 5+),
# but rails 4 does not require providing that and consumes only params, session and flash.
# Integration specs does not have session and flash but we don't require them so we will skip them.
# Integration requests can also pass headers, but we don't use it yet.
# https://github.com/rails/rails/blob/v6.0.3.6/actionpack/lib/action_dispatch/testing/integration.rb#L211
# Please use this helper methods and use keyword arguments.
# For get requests you should provide another helper integrating params, etc.
def post_with_rails_fix(url, params: {}, **others)
  if Rails::VERSION::MAJOR >= 5
    post url, params: params, **others
  else
    post url, params, **others
  end
end

# Similar helper to post, providing compability to controller/request specs for rails 4
def patch_with_rails_fix(url, params: {}, **others)
  if Rails::VERSION::MAJOR >= 5
    patch url, params: params, **others
  else
    patch url, params, **others
  end
end
