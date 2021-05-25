module JsonApi
  module Parameters
    module Handlers
      module DefaultHandlers
        class BaseHandler
          attr_reader :relationship_key, :relationship_value, :included

          def self.call(key, val, included)
            new(key, val, included).handle
          end

          def initialize(relationship_key, relationship_value, included)
            @relationship_key = relationship_key
            @relationship_value = relationship_value
            @included = included
          end

          def find_included_object(related_id:, related_type:)
            included.find do |included_object_enum|
              included_object_enum[:id] &&
                included_object_enum[:id] == related_id &&
                included_object_enum[:type] &&
                included_object_enum[:type] == related_type
            end
          end

          def build_included_object(included_object, related_id)
            included_object_base(included_object).tap do |body|
              body[:id] = related_id unless client_generated_id?(related_id)
              body[:relationships] = included_object[:relationships] if included_object.key?(:relationships) # Pass nested relationships
            end
          end

          def included_object_base(included_object)
            { **(included_object[:attributes] || {}) }
          end

          def client_generated_id?(related_id)
            related_id.to_s.starts_with?(JsonApi::Parameters.client_id_prefix)
          end
        end
      end
    end
  end
end
