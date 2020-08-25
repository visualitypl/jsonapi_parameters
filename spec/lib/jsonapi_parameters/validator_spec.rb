require 'spec_helper'

describe JsonApi::Parameters::Validator do # rubocop:disable RSpec/FilePath
  describe 'initializer' do
    it 'ensures @payload has keys deeply stringified' do
      validator = described_class.new(payload: { sample: 'value' })

      expect(validator.payload.keys).to include('payload')
      expect(validator.payload['payload'].keys).to include('sample')
    end

    context 'validations' do
      let(:translator) do
        class Translator
          include JsonApi::Parameters
        end

        Translator.new
      end

      describe 'with prevalidation enforced' do
        before { JsonApi::Parameters.enforce_prevalidation = true }

        after { JsonApi::Parameters.enforce_prevalidation = false }

        it 'raises validation errors' do
          payload = { payload: { sample: 'value' } }

          expect { translator.jsonapify(payload) }.to raise_error(ActiveModel::ValidationError)
        end

        it 'does not raise TranslatorError' do
          payload = { payload: { sample: 'value' } }

          expect { translator.jsonapify(payload) }.not_to raise_error(JsonApi::Parameters::TranslatorError)
        end

        it 'does not call formed_parameters' do
          payload = { payload: { sample: 'value' } }

          expect(translator).not_to receive(:formed_parameters)

          begin
            translator.jsonapify(payload)
          rescue ActiveModel::ValidationError => _ # rubocop:disable Lint/HandleExceptions
          end
        end
      end

      describe 'suppression enabled' do
        before { JsonApi::Parameters.suppress_validation_errors = true }

        after { JsonApi::Parameters.suppress_validation_errors = false }

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
