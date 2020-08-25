require 'active_model'
require 'json_schemer'

module JsonApi::Parameters
  SCHEMA_PATH = 'spec/support/jsonapi_schema.json'.freeze

  class Validator
    include ActiveModel::Validations

    attr_reader :payload

    class PayloadValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        @schema = JSONSchemer.schema(File.read(SCHEMA_PATH))

        unless @schema.valid?(value) # rubocop:disable Style/GuardClause
          @schema.validate(value).each do |validation_error|
            record.errors[attribute] << nice_error(validation_error)
          end
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

    validates :payload, presence: true, payload: true

    def initialize(payload)
      @payload = payload.deep_stringify_keys
    end
  end
end
