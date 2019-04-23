require 'spec_helper'

describe ActionController::Parameters do
  it 'responds to #from_jsonapi' do
    expect(described_class.new.respond_to?(:from_jsonapi)).to eq(true)
  end

  describe '#from_jsonapi' do
    it 'returns new object' do
      params = described_class.new

      expect(params.from_jsonapi.hash).not_to eq(params.hash)
    end

    it 'is memoized' do
      params = described_class.new

      expect(params.from_jsonapi.hash).to eq(params.from_jsonapi.hash)
    end
  end
end
