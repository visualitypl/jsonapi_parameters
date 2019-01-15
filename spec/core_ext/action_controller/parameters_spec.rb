require 'spec_helper'

describe ActionController::Parameters do
  it 'responds to #to_jsonapi' do
    expect(described_class.new.respond_to?(:to_jsonapi)).to eq(true)
  end

  describe '#to_jsonapi' do
    it 'returns new object' do
      params = described_class.new

      expect(params.to_jsonapi.hash).not_to eq(params.hash)
    end

    it 'is memoized' do
      params = described_class.new

      expect(params.to_jsonapi.hash).to eq(params.to_jsonapi.hash)
    end
  end
end
