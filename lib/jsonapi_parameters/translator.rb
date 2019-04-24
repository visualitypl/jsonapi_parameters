module JsonApi::Parameters
  def jsonapify(params, naming_convention: :snake)
    jsonapi_translate(params, naming_convention: naming_convention)
  end

  private

  def jsonapi_translate(params, naming_convention:)
    params = params.to_unsafe_h if params.is_a?(ActionController::Parameters)

    return params if params.nil? || params.empty?

    @jsonapi_unsafe_hash = if naming_convention != :snake || JsonApi::Parameters.ensure_underscore_translation
                             params.deep_transform_keys { |key| key.to_s.underscore.to_sym }
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

        key, val = case relationship_value
                   when Array
                     handle_to_many_relation(relationship_key, relationship_value)
                   when Hash
                     handle_to_one_relation(relationship_key, relationship_value)
                   else
                     raise jsonapi_not_implemented_err
                   end
        param[key] = val
      end
    end
  end

  def jsonapi_unsafe_params
    @jsonapi_unsafe_params ||= @jsonapi_unsafe_hash.dig(:data, :attributes) || {}
  end

  def jsonapi_included
    @jsonapi_included ||= @jsonapi_unsafe_hash[:included] || []
  end

  def jsonapi_relationships
    @jsonapi_relationships ||= @jsonapi_unsafe_hash.dig(:data, :relationships) || []
  end

  def handle_to_many_relation(relationship_key, relationship_value)
    key = "#{relationship_key.to_s.pluralize}_attributes".to_sym

    val = relationship_value.map do |relationship_value|
      related_id = relationship_value.dig(:id)
      related_type = relationship_value.dig(:type)

      included_object = find_included_object(
        related_id: related_id, related_type: related_type
      ) || {}

      included_object.delete(:type)

      included_object[:attributes].merge(id: related_id)
    end

    [key, val]
  end

  def handle_to_one_relation(relationship_key, relationship_value)
    related_id = relationship_value.dig(:id)
    related_type = relationship_key.to_s

    included_object = find_included_object(
      related_id: related_id, related_type: related_type
    )

    return ["#{related_type.singularize}_id".to_sym, related_id] if included_object.nil?

    included_object.delete(:type)
    ["#{related_type.singularize}_attributes".to_sym, included_object]
  end

  def find_included_object(related_id:, related_type:)
    jsonapi_included.find do |included_object_enum|
      included_object_enum[:id] &&
        included_object_enum[:id] == related_id &&
        included_object_enum[:type] &&
        included_object_enum[:type] == related_type
    end
  end

  def jsonapi_not_implemented_err
    NotImplementedError.new('relationship member must either be an Array or a Hash')
  end
end
