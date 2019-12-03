require_relative 'default_handlers/nil_relation_handler'
require_relative 'default_handlers/to_many_relation_handler'
require_relative 'default_handlers/to_one_relation_handler'

module JsonApi
  module Parameters
    module Handlers
      include DefaultHandlers

      module_function

      def add_handler(handler_name, klass)
        handlers[handler_name.to_sym] = klass
      end

      def set_resource_handler(resource_key, handler_key)
        unless handlers.key?(handler_key)
          raise NotImplementedError.new(
            'handler_key does not match any registered handlers'
          )
        end

        resource_handlers[resource_key.to_sym] = handler_key.to_sym
      end

      def resource_handlers
        @resource_handlers ||= {}
      end

      def handlers
        @handlers ||= {
          to_many: ->(k, v, included) { ToManyRelationHandler.new(k, v, included).handle },
          to_one: ->(k, v, included) { ToOneRelationHandler.new(k, v, included).handle },
          nil: ->(k, v, included) { NilRelationHandler.new(k, v, included).handle }
        }
      end
    end
  end
end
