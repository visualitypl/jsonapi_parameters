module JsonApi
  module Parameters
    @ensure_underscore_translation = false
    @suppress_schema_validation_errors = false
    @enforce_schema_prevalidation = false

    class << self
      attr_accessor :ensure_underscore_translation
      attr_accessor :suppress_schema_validation_errors
      attr_accessor :enforce_schema_prevalidation
    end
  end
end
