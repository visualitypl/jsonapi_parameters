require_relative './base_handler'

module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class NilRelationHandler < BaseHandler
          include ActiveSupport::Inflector

          def handle
            # Graceful fail if nil on to-many association
            # in case the relationship key is, for instance, `billable_hours`,
            # we have to assume that it is a to-many relationship.
            if pluralize(relationship_key).to_sym == relationship_key
              raise NotImplementedError.new(
                'plural resource cannot be nullified - please create a custom handler for this relation'
              )
            end

            # Handle with empty hash.
            ToOneRelationHandler.new(relationship_key, {}, {}).handle
          end
        end
      end
    end
  end
end
