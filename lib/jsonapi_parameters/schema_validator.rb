require 'json_schemer'

module JsonApi::Parameters
  SCHEMA_PATH = Pathname.new(__dir__).join('jsonapi_schema.json').to_s.freeze

  private

  def should_prevalidate?
    JsonApi::Parameters.enforce_schema_prevalidation && !JsonApi::Parameters.suppress_schema_validation_errors
  end

  class SchemaValidator
    class ValidationError < StandardError; end

    def initialize(payload)
      @payload = payload.deep_stringify_keys
    end

    attr_reader :payload

    def validate!
      schema = JSONSchemer.schema(File.read(SCHEMA_PATH))

      unless schema.valid?(payload) # rubocop:disable Style/GuardClause
        errors = []

        schema.validate(payload).each do |validation_error|
          errors << nice_error(validation_error)
        end

        raise SchemaValidator::ValidationError.new(errors.join(', '))
      end
    end

    private

    # Based on & thanks to https://polythematik.de/2020/02/17/ruby-json-schema/
    def nice_error(err)
      case err['type']
      when 'required'
        "path '#{err['data_pointer']}' is missing keys: #{err['details']['missing_keys'].join ', '}"
      when 'format'
        "path '#{err['data_pointer']}' is not in required format (#{err['schema']['format']})"
      when 'minLength'
        "path '#{err['data_pointer']}' is not long enough (min #{err['schema']['minLength']})"
      else
        "path '#{err['data_pointer']}' is invalid according to the JsonApi schema"
      end
    end
  end
end
