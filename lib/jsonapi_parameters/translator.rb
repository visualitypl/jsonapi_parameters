module JsonApi::Parameters
  def jsonapify(params)
    jsonapi_translate(params)
  end

  private

  def jsonapi_translate(params)
    params = params.to_unsafe_h if params.is_a?(ActionController::Parameters)

    return params if params.nil? || params.empty?

    @_jsonapi_unsafe_hash = params.deep_symbolize_keys

    formed_parameters
  end

  def formed_parameters
    @formed_parameters ||= {}.tap do |param|
      param[jsonapi_main_key.to_sym] = jsonapi_main_body
  end
  end

  def jsonapi_main_key
    @_jsonapi_unsafe_hash.dig(:data, :type)&.singularize
  end

  def jsonapi_main_body
    params = @_jsonapi_unsafe_hash.dig(:data, :attributes) || {}

    params.tap do |param|
      jsonapi_relationships.each do |relationship_key, relationship_value|


        if relationship_value.is_a?(Array) # to-many relationships
          key = "#{relationship_key.to_s.pluralize}_attributes".to_sym

          val = relationship_value.map do |relationship_value|
            related_id = relationship_value.dig(:data, :id)
            related_type = relationship_value.dig(:data, :type)

            included_object = find_included_object(
              related_id: related_id, related_type: related_type
            ) || {}

            included_object.delete(:type)

            included_object[:attributes].merge(id: related_id)
          end

          params[key] = val
        elsif relationship_value.is_a?(Hash)
          related_id = relationship_value.dig(:data, :id)
          related_type = relationship_key.to_s

          included_object = find_included_object(
            related_id: related_id, related_type: related_type
          )

          if included_object.nil?
            params["#{related_type.singularize}_id".to_sym] = related_id
          else
            included_object.delete(:type)

            params["#{related_type.singularize}_attributes".to_sym] = included_object
          end
        else
          raise NotImplementedError, 'relationship member must either be an Array or a Hash'
        end
      end
    end
  end

  def jsonapi_included
    @_jsonapi_included ||= @_jsonapi_unsafe_hash[:included] || []
  end

  def jsonapi_relationships
    @_jsonapi_relationships ||= @_jsonapi_unsafe_hash.dig(:data, :relationships) || []
  end

  def find_included_object(related_id:, related_type:)
    jsonapi_included.find do |included_object_enum|
      included_object_enum[:id] &&
      included_object_enum[:id] == related_id &&
      included_object_enum[:type] &&
      included_object_enum[:type] == related_type
    end
  end
end
