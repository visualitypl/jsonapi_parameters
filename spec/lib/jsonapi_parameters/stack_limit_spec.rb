require 'spec_helper'

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe Translator do # rubocop:disable RSpec/FilePath
  context 'with default stack limit' do
    it 'works properly if the stack level is the same as the limit' do
      input = select_input_by_name('POST create payloads', 'triple-nested payload')

      translator = described_class.new

      expect { translator.jsonapify(input) }.not_to raise_error(JsonApi::Parameters::StackLevelTooDeepError)
      expect { translator.jsonapify(input) }.not_to raise_error # To ensure this is passing
    end

    it 'raises an error if the stack level is above the limit' do
      input = select_input_by_name('POST create payloads', 'triple-nested payload')

      input[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }

      translator = described_class.new

      expect { translator.jsonapify(input) }.to raise_error(JsonApi::Parameters::StackLevelTooDeepError)
    end
  end

  context 'stack limit' do
    it 'can be overwritten' do
      input = select_input_by_name('POST create payloads', 'triple-nested payload')
      input[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }
      translator = described_class.new
      translator.stack_limit = 4

      expect { translator.jsonapify(input) }.not_to raise_error(JsonApi::Parameters::StackLevelTooDeepError)
      expect { translator.jsonapify(input) }.not_to raise_error # To ensure this is passing
    end

    it 'can be overwritten using short notation' do
      input = select_input_by_name('POST create payloads', 'triple-nested payload')
      input[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }
      translator = described_class.new

      expect { translator.jsonapify(input, custom_stack_limit: 4) }.not_to raise_error(JsonApi::Parameters::StackLevelTooDeepError)
      expect { translator.jsonapify(input, custom_stack_limit: 4) }.not_to raise_error # To ensure this is passing
    end

    it 'can be reset' do
      input = select_input_by_name('POST create payloads', 'triple-nested payload')
      input[:included] << { id: 3, type: 'entity', relationships: { subentity: { data: { type: 'entity', id: 4 } } } }
      translator = described_class.new
      translator.stack_limit = 4

      translator.reset_stack_limit

      expect { translator.jsonapify(input) }.to raise_error(JsonApi::Parameters::StackLevelTooDeepError)
    end
  end
end
