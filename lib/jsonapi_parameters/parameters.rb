module JsonApi
  module Parameters
    @ensure_underscore_translation = false
    @ignore_ids_with_prefix = nil

    class << self
      attr_accessor :ensure_underscore_translation
      attr_accessor :ignore_ids_with_prefix
    end
  end
end
