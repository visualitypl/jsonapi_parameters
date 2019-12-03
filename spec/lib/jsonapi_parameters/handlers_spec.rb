require 'spec_helper'

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe JsonApi::Parameters::Handlers do
  describe 'custom handlers' do
    it 'allows to add a custom handler' do
      expect(described_class.add_handler(:test, -> { puts 'Hello!' })).to be_an_instance_of(Proc)
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
  it 'properly translates with custom resource handler' do
    trs = described_class.new
    params = {
      data: {
        type: 'users',
        id: '666',
        attributes: {
          first_name: 'John'
        },
        relationships: {
          horses: { data: nil }
        }
      }
    }

    horse_handler = ->(relationship_key, _, _) { ["#{relationship_key}_id".to_sym, nil] }

    JsonApi::Parameters::Handlers.add_handler(:handle_plural_nil_as_belongs_to_nil, horse_handler)
    JsonApi::Parameters::Handlers.set_resource_handler(:horses, :handle_plural_nil_as_belongs_to_nil)

    result = trs.jsonapify(params)

    expect(result).to eq(
      user: { first_name: 'John', id: '666', horses_id: nil }
    )
  end
end
