require_relative 'default_handlers/nil_relation_handler'
require_relative 'default_handlers/to_many_relation_handler'
require_relative 'default_handlers/to_one_relation_handler'

module JsonApi
  module Parameters
    module Handlers
      include DefaultHandlers

      DEFAULT_HANDLER_SET = {
        to_many: ToManyRelationHandler,
        to_one: ToOneRelationHandler,
        nil: NilRelationHandler
      }.freeze

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

      def reset_handlers
        @handlers = DEFAULT_HANDLER_SET.dup
        @resource_handlers = {}
      end

      def resource_handlers
        @resource_handlers ||= {}
      end

      def handlers
        @handlers ||= DEFAULT_HANDLER_SET.dup
      end
    end
  end
end
