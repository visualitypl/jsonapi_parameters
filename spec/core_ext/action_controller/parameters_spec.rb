require 'spec_helper'

describe ActionController::Parameters do
  it 'responds to #to_jsonapi!' do
    expect(described_class.new.respond_to?(:to_jsonapi!)).to eq(true)
  end
end
