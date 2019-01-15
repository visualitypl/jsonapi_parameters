require 'spec_helper'

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe Translator do
  describe 'plain hash parameters' do
    JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
      describe case_type_name do
        kases.each do |kase|
          kase.each do |case_name, case_data|
            it "matches #{case_name}" do
              input, predicted_output = case_data

              expect(described_class.new.jsonapify(input)).to eq(predicted_output)
            end
          end
        end
      end
    end
  end

  describe 'parameters instantiated as ActionController::Parameters' do
    JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
      describe case_type_name do
        kases.each do |kase|
          kase.each do |case_name, case_data|
            it "matches #{case_name}" do
              input, predicted_output = case_data
              input = ActionController::Parameters.new(input)

              expect(described_class.new.jsonapify(input)).to eq(predicted_output)
            end
          end
        end
      end
    end
  end
end
