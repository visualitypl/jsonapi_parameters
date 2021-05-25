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

            return ["#{singularize(relationship_key)}_id".to_sym, related_id] if included_object.empty?

            included_object = { **(included_object[:attributes] || {}) }.tap do |body|
              body[:id] = related_id unless client_generated_id?(related_id)
              body[:relationships] = included_object[:relationships] if included_object.key?(:relationships) # Pass nested relationships
            end

            ["#{singularize(relationship_key)}_attributes".to_sym, included_object]
          end
        end
      end
    end
  end
end
