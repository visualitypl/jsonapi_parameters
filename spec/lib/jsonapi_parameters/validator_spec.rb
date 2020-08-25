require 'spec_helper'

describe JsonApi::Parameters::Validator do # rubocop:disable RSpec/FilePath
  describe 'initializer' do
    it 'ensures @payload has keys deeply stringified' do
      validator = described_class.new(payload: { sample: 'value' })

      expect(validator.payload.keys).to include('payload')
      expect(validator.payload['payload'].keys).to include('sample')
    end

    context 'validations' do
      describe 'suppression enabled' do
        before { JsonApi::Parameters.suppress_validation_errors = true }

        after { JsonApi::Parameters.suppress_validation_errors = false }

        let(:translator) do
          class Translator
            include JsonApi::Parameters
          end

          Translator.new
        end

        it 'does not raise validation errors' do
          payload = { payload: { sample: 'value' } }

          expect { translator.jsonapify(payload) }.not_to raise_error(ActiveModel::ValidationError)
        end

        it 'still raises any other errors' do
          payload = { payload: { sample: 'value' } }

          expect { translator.jsonapify(payload) }.to raise_error(JsonApi::Parameters::TranslatorError)
        end
      end

      describe 'suppression disabled by default' do
        let(:translator) do
          class Translator
            include JsonApi::Parameters
          end

          Translator.new
        end

        it 'does not raise validation errors' do
          payload = { payload: { sample: 'value' } }

          expect { translator.jsonapify(payload) }.to raise_error(ActiveModel::ValidationError)
          expect { translator.jsonapify(payload) }.not_to raise_error(JsonApi::Parameters::TranslatorError)
        end
      end

      it 'loads JsonApi schema' do
        payload = { payload: { sample: 'value' } }
        validator = described_class.new(payload)

        expect(File).to receive(:read).with(JsonApi::Parameters::SCHEMA_PATH).and_call_original
        expect(JSONSchemer).to receive(:schema).and_call_original

        expect { validator.validate! }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end
end
