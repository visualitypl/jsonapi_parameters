require 'active_support/inflector'

module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class ToManyRelationHandler < BaseHandler
          include ActiveSupport::Inflector

          attr_reader :with_inclusion, :vals, :key

          def handle
            @with_inclusion = !relationship_value.empty?

            prepare_relationship_vals

            generate_key

            [key, vals]
          end

          private

          def prepare_relationship_vals
            @vals = relationship_value.map do |relationship|
              related_id = relationship.dig(:id)
              related_type = relationship.dig(:type)

              included_object = find_included_object(
                related_id: related_id, related_type: related_type
              ) || {}

              # If at least one related object has not been found in `included` tree,
              # we should not attempt to "#{relationship_key}_attributes" but
              # "#{relationship_key}_ids" instead.
              @with_inclusion &= !included_object.empty?

              if with_inclusion
                { **(included_object[:attributes] || {}), id: related_id }.tap do |body|
                  body[:relationships] = included_object[:relationships] if included_object.key?(:relationships) # Pass nested relationships
                end
              else
                relationship.dig(:id)
              end
            end
          end

          def generate_key
            @key = (with_inclusion ? "#{pluralize(relationship_key)}_attributes" : "#{singularize(relationship_key)}_ids").to_sym
          end
        end
      end
    end
  end
end
