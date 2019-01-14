module JsonApi::Parameters
  def jsonapify(params)
    jsonapi_translate(params)
  end

  private

  def jsonapi_translate(params)
    params = params.to_unsafe_h if params.is_a?(ActionController::Parameters)

    @_jsonapi_unsafe_hash = params.deep_symbolize_keys

    formed_parameters
  end

  def formed_parameters
    @formed_parameters ||= {}.tap do |param|
      param[jsonapi_main_key.to_sym] = jsonapi_main_body
    end
  end

  def jsonapi_main_key
    @_jsonapi_unsafe_hash.dig(:data, :type)
  end

  def jsonapi_main_body
    @_jsonapi_unsafe_hash.dig(:data, :attributes)
  end
end
