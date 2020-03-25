module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class ToManyRelationHandler < BaseHandler
          include ActiveSupport::Inflector

          def handle
            [key, vals]
          end

          private

          def key
            @key ||= if with_inclusion
                       "#{pluralize(relationship_key)}_attributes".to_sym
                     else
                       "#{singularize(relationship_key)}_ids".to_sym
                     end
          end

          def vals
            @vals ||= relationship_value.map do |relationship|
              related_id = relationship.dig(:id)
              related_type = relationship.dig(:type)

              included_object =
                find_embedded_object(relationship: relationship) ||
                find_included_object(related_id: related_id, related_type: related_type) ||
                {}

              if included_object.empty?
                relationship.dig(:id)
              else
                included_object[:attributes].merge(id: related_id)
              end
            end
          end

          def with_inclusion
            # If at least one related object has not been found in `included` tree,
            # all relationship objects are not treated as included
            @with_inclusion ||= vals.present? && vals.all? { |v| v.kind_of? Hash }
          end
        end
      end
    end
  end
end
