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

            included_object = build_included_object(included_object, related_id)

            ["#{singularize(relationship_key)}_attributes".to_sym, included_object]
          end
        end
      end
    end
  end
end
