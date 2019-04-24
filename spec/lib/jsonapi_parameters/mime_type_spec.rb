require 'spec_helper'

describe Mime::Type do # rubocop:disable RSpec/FilePath
  result = described_class.lookup_by_extension(:json).instance_variable_get(:@synonyms)

  it 'includes JSON:API application/vnd.api+json mime type registered as json' do
    expect(result.include?('application/vnd.api+json')).to eq(true)
  end

  it 'includes standard application/json mime type registered as json' do
    expect(result.include?('application/json')).to eq(true)
  end
end
