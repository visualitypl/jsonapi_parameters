require 'active_support/inflector'

module JsonApi::Parameters
  include ActiveSupport::Inflector

  def jsonapify(params, naming_convention: :snake)
    jsonapi_translate(params, naming_convention: naming_convention)
  end

  private

  def jsonapi_translate(params, naming_convention:)
    params = params.to_unsafe_h if params.is_a?(ActionController::Parameters)

    return params if params.nil? || params.empty?

    @jsonapi_unsafe_hash = if naming_convention != :snake || JsonApi::Parameters.ensure_underscore_translation
                             params = params.deep_transform_keys { |key| key.to_s.underscore.to_sym }
                             params[:data][:type] = params[:data][:type].underscore if params.dig(:data, :type)
                             params
                           else
                             params.deep_symbolize_keys
                           end

    formed_parameters
  end

  def formed_parameters
    @formed_parameters ||= {}.tap do |param|
      param[jsonapi_main_key.to_sym] = jsonapi_main_body
    end
  end

  def jsonapi_main_key
    @jsonapi_unsafe_hash.dig(:data, :type)&.singularize || ''
  end

  def jsonapi_main_body
    jsonapi_unsafe_params.tap do |param|
      jsonapi_relationships.each do |relationship_key, relationship_value|
        relationship_value = relationship_value[:data]
        handler_args = [relationship_key, relationship_value, jsonapi_included]
        handler = if Handlers.resource_handlers.key?(relationship_key)
                    Handlers.handlers[Handlers.resource_handlers[relationship_key]]
                  else
                    case relationship_value
                    when Array
                      Handlers.handlers[:to_many]
                    when Hash
                      Handlers.handlers[:to_one]
                    when nil
                      Handlers.handlers[:nil]
                    else
                      raise NotImplementedError.new('relationship resource linkage has to be a type of Array, Hash or nil')
                    end
                  end

        key, val = handler.call(*handler_args)
        param[key] = val
      end
    end
  end

  def jsonapi_unsafe_params
    @jsonapi_unsafe_params ||= (@jsonapi_unsafe_hash.dig(:data, :attributes) || {}).tap do |param|
      id = @jsonapi_unsafe_hash.dig(:data, :id)

      param[:id] = id if id.present?
    end
  end

  def jsonapi_included
    @jsonapi_included ||= @jsonapi_unsafe_hash[:included] || []
  end

  def jsonapi_relationships
    @jsonapi_relationships ||= @jsonapi_unsafe_hash.dig(:data, :relationships) || []
  end
end
