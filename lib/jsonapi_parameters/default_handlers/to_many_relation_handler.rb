module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class ToManyRelationHandler < BaseHandler
          include ActiveSupport::Inflector

          def handle
            with_inclusion = !relationship_value.empty?

            vals = relationship_value.map do |relationship|
              related_id = relationship.dig(:id)
              related_type = relationship.dig(:type)

              included_object = find_included_object(
                related_id: related_id, related_type: related_type
              ) || {}

              # If at least one related object has not been found in `included` tree,
              # we should not attempt to "#{relationship_key}_attributes" but
              # "#{relationship_key}_ids" instead.
              with_inclusion &= !included_object.empty?

              if with_inclusion
                included_object.delete(:type)
                included_object[:attributes].merge(id: related_id)
              else
                relationship.dig(:id)
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
        end
      end
    end
  end
end
