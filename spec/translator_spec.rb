require 'spec_helper'

####
# Input-Output translator test cases
####
test_cases = [
  [
    { data: { type: 'test', attributes: { name: 'test name' } } },
    { test: { name: 'test name' } }
  ]
]

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe Translator do
  it 'matches all test cases' do
    test_cases.each do |test_case|
      input, predicted_output = test_case

      expect(described_class.new.jsonapify(input)).to eq(predicted_output)
    end
  end

  it 'matches all test cases (instantiated as ActionController::Parameter)' do
    test_cases.each do |test_case|
      input, predicted_output = test_case
      input = ActionController::Parameters.new(input)

      expect(described_class.new.jsonapify(input)).to eq(predicted_output)
    end
  end
end
