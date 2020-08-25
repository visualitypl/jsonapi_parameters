module JsonApi
  module Parameters
    @ensure_underscore_translation = false
    @supress_validation_errors = false

    class << self
      attr_accessor :ensure_underscore_translation
      attr_accessor :suppress_validation_errors
    end
  end
end
