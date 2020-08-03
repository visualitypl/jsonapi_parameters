module JsonApi
  module Parameters
    LIMIT = 3

    class StackLevelTooDeep < StandardError
    end

    def stack_limit=(val)
      @stack_limit = val
    end

    def stack_limit
      @stack_limit ||= LIMIT
    end

    def reset_stack_limit!
      @stack_limit = LIMIT
    end

    private

    def increment_stack_level!
      @current_stack_level ||= 0

      @current_stack_level += 1

      raise StackLevelTooDeep.new(stack_exception_message) if @current_stack_level > stack_limit
    end

    def reset_stack_level!
      @current_stack_level = 0
    end

    def stack_exception_message
      "Stack level of nested payload is too deep: #{@current_stack_level}/#{stack_limit}. Please see the documentation on how to overwrite the limit."
    end
  end
end
