module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class ToOneRelationHandler < BaseHandler
          include ActiveSupport::Inflector

          def handle
            if included_object.empty?
              [key, related_id]
            else
              included_atttributes = included_object[:attributes].merge(id: related_id)
              [key, included_atttributes]
            end
          end

          private

          def included_object
            @included_object ||= begin
              related_type = relationship_value.dig(:type)
              find_embedded_object(relationship: relationship_value) ||
              find_included_object(related_id: related_id, related_type: related_type) ||
              {}
            end
          end

          def key
            @key ||= if included_object.empty?
                       "#{singularize(relationship_key)}_id".to_sym
                     else
                       "#{singularize(relationship_key)}_attributes".to_sym
                     end
          end

          def related_id
            @related_id ||= relationship_value.dig(:id)
          end
        end
      end
    end
  end
end
