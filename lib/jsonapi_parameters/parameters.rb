module JsonApi
  module Parameters
    @ensure_underscore_translation = false
    @suppress_validation_errors = false
    @enforce_prevalidation = false

    class << self
      attr_accessor :ensure_underscore_translation
      attr_accessor :suppress_validation_errors
      attr_accessor :enforce_prevalidation
    end
  end
end
