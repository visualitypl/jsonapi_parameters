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
                   when nil
                     handle_nil_relation(relationship_key)
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
    with_inclusion = true

    vals = relationship_value.map do |relationship_value|
      related_id = relationship_value.dig(:id)
      related_type = relationship_value.dig(:type)

      included_object = find_included_object(
        related_id: related_id, related_type: related_type
      ) || {}

      # If at least one related object has not been found in `included` tree,
      # we should not attempt to "#{relationship_key}_attributes" but
      # "#{relationship_key}_ids" instead.
      with_inclusion = with_inclusion ? !included_object.empty? : with_inclusion

      if with_inclusion
        included_object.delete(:type)
        included_object[:attributes].merge(id: related_id)
      else
        relationship_value.dig(:id)
      end
    end

    # We may have smells in our value array as `with_inclusion` may have been changed at some point
    # but not in the beginning.
    # Because of that we should clear it and make sure the results are unified (e.g. array of ids)
    unless with_inclusion
      vals.map do |val|
        val.dig(:attributes, :id) if val.is_a?(Hash)
      end
    end

    key = with_inclusion ? "#{pluralize(relationship_key)}_attributes".to_sym : "#{singularize(relationship_key)}_ids".to_sym

    [key, vals]
  end

  def handle_to_one_relation(relationship_key, relationship_value)
    related_id = relationship_value.dig(:id)
    related_type = relationship_value.dig(:type)

    included_object = find_included_object(
      related_id: related_id, related_type: related_type
    ) || {}

    return ["#{singularize(relationship_key)}_id".to_sym, related_id] if included_object.empty?

    included_object.delete(:type)
    included_object = included_object[:attributes].merge(id: related_id)
    ["#{singularize(relationship_key)}_attributes".to_sym, included_object]
  end

  def handle_nil_relation(relationship_key)
    # Graceful fail if nil on to-many association.
    raise jsonapi_not_implemented_err if pluralize(relationship_key).to_sym == relationship_key

    # Handle with empty hash.
    handle_to_one_relation(relationship_key, {})
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
