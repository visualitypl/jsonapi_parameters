require 'active_support/inflector'

module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class ToOneRelationHandler < BaseHandler
          include ActiveSupport::Inflector

          def handle
            related_id = relationship_value.dig(:id)
            related_type = relationship_value.dig(:type)

            included_object = find_included_object(
              related_id: related_id, related_type: related_type
            ) || {}

            # We call `related_id&.to_s` because we want to make sure NOT to end up with `nil.to_s`
            # if `related_id` is nil, it should remain nil, to nullify the relationship
            return ["#{singularize(relationship_key)}_id".to_sym, related_id&.to_s] if included_object.empty?

            included_object = { **(included_object[:attributes] || {}), id: related_id.to_s }.tap do |body|
              body[:relationships] = included_object[:relationships] if included_object.key?(:relationships) # Pass nested relationships
            end

            ["#{singularize(relationship_key)}_attributes".to_sym, included_object]
          end
        end
      end
    end
  end
end
