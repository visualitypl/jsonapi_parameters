require 'spec_helper'

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe JsonApi::Parameters::Handlers do
  before(:each) do
    described_class.reset_handlers
  end

  describe 'reset_handlers!' do
    it 'sets all the handlers to the default handlers' do
      handler = described_class.add_handler(:test, -> { puts 'Hello!' })

      expect(described_class::DEFAULT_HANDLER_SET).not_to include(handler)

      described_class.reset_handlers

      expect(described_class.handlers).not_to include(handler)
      expect(described_class.handlers).to eq(described_class::DEFAULT_HANDLER_SET)
    end

    it 'empties the resource handlers' do
      described_class.add_handler(:test, -> { puts 'Hello!' })
      described_class.set_resource_handler(:test, :test)

      described_class.reset_handlers

      expect(described_class.resource_handlers).to eq({})
    end
  end

  describe 'custom handlers' do
    it 'allows to add a custom handler' do
      handler = described_class.add_handler(:test, -> { puts 'Hello!' })

      expect(handler).to be_an_instance_of(Proc)
      expect(described_class.handlers.values).to include(handler)
    end
  end

  describe 'custom resource handler' do
    it 'allows to set a custom resource handler when the handler is present' do
      expect(described_class.add_handler(:test, -> { puts 'Hello!' })).to be_an_instance_of(Proc)
      expect { described_class.set_resource_handler(:test, :test) }.not_to raise_error
    end

    it 'disallows setting a custom resource handler when the handler is not present' do
      expect { described_class.set_resource_handler(:test2, :test2) }.to raise_error(NotImplementedError)
    end
  end
end

describe Translator do
  before(:each) do
    JsonApi::Parameters::Handlers.reset_handlers
  end

  context 'edge case of singular resource with a plural name (scissors)' do
    it 'properly translates with custom resource handler' do
      translator = described_class.new
      params = {
        data: {
          type: 'users',
          id: '666',
          attributes: {
            first_name: 'John'
          },
          relationships: {
            scissors: { data: nil }
          }
        }
      }

      scissors_handler = ->(relationship_key, _, _) { ["#{relationship_key}_id".to_sym, nil] }

      JsonApi::Parameters::Handlers.add_handler(:handle_plural_nil_as_belongs_to_nil, scissors_handler)
      JsonApi::Parameters::Handlers.set_resource_handler(:scissors, :handle_plural_nil_as_belongs_to_nil)

      result = translator.jsonapify(params)

      expect(result).to eq(
        user: { first_name: 'John', id: '666', scissors_id: nil }
      )
    end

    it 'would fail with NotImplementedError if no customizations present' do
      translator = described_class.new
      params = {
        data: {
          type: 'users',
          id: '666',
          attributes: {
            first_name: 'John'
          },
          relationships: {
            scissors: { data: nil }
          }
        }
      }

      expect { translator.jsonapify(params) }.to raise_error(NotImplementedError)
    end
  end
end
