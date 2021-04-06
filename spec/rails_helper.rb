require 'spec_helper'
require 'rails'
require 'rspec/rails'
require 'json'

load "#{Rails.root}/db/schema.rb"

def jsonapi_response
  JSON.parse(response.body, symbolize_names: true)
end

# rails changed test case request params from positional to keywords in rails 5.1.7
# 5.1.6>= rails >=5.0 consumes both ways.
# https://apidock.com/rails/v5.1.7/ActionController/TestCase/Behavior/process
# others keywords can be: session, body, flash, format, xhr, as.
# We are using `as: json` in specs (rails 5+),
# but rails 4 does not require providing that and consumes only params, session and flash.
# Please use this helper methods and use keyword arguments.
# For get requests you should provide another helper integrating params, etc.
def post_with_rails_fix(url, params: {}, session: nil, flash: nil, **others)
  if Rails::VERSION::MAJOR >= 5
    post url, params: params, session: session, flash: flash, **others
  else
    post url, params, session, flash
  end
end

# Similar helper to post, providing compability to controller/request specs for rails 4
def patch_with_rails_fix(url, params: {}, session: nil, flash: nil, **others)
  if Rails::VERSION::MAJOR >= 5
    patch url, params: params, session: session, flash: flash, **others
  else
    patch url, params, session, flash
  end
end
