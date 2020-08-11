class StackTesterController < ApplicationController
  def stack_default
    params.from_jsonapi # Try parsing!

    head 200
  end

  def stack_custom_limit
    parse_params_custom

    head 200
  end

  def short_stack_custom_limit
    params.from_jsonapi(custom_stack_limit: 4)

    head 200
  end

  private

  def parse_params_custom
    params.stack_limit = 4

    params.from_jsonapi
  ensure
    params.reset_stack_limit
  end
end
