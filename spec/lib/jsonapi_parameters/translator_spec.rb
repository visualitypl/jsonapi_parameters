require 'spec_helper'

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe Translator do
  context 'without enforced underscore translation' do
    describe 'plain hash parameters' do
      JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
        describe case_type_name do
          kases.each do |kase|
            kase.each do |case_name, case_data|
              it "matches #{case_name}" do
                input, predicted_output = case_data

                translated_input = described_class.new.jsonapify(input)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])
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

                translated_input = described_class.new.jsonapify(input)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])
              end
            end
          end
        end
      end
    end

    describe 'camelCased parameters' do
      JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
        describe case_type_name do
          kases.each do |kase|
            kase.each do |case_name, case_data|
              it "matches #{case_name}" do
                input, predicted_output = case_data
                input[:data][:type] = input[:data][:type].camelize
                input = input.deep_transform_keys { |key| key.to_s.camelize.to_sym }
                input = ActionController::Parameters.new(input)

                translated_input = described_class.new.jsonapify(input, naming_convention: :camel)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])
              end
            end
          end
        end
      end
    end

    describe 'dasherized parameters' do
      JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
        describe case_type_name do
          kases.each do |kase|
            kase.each do |case_name, case_data|
              it "matches #{case_name}" do
                input, predicted_output = case_data
                input[:data][:type] = input[:data][:type].dasherize
                input = input.deep_transform_keys { |key| key.to_s.dasherize.to_sym }
                input = ActionController::Parameters.new(input)

                translated_input = described_class.new.jsonapify(input, naming_convention: :dashed)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])
              end
            end
          end
        end
      end
    end
  end

  context 'with enforced underscore translation' do
    describe 'plain hash parameters' do
      JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
        describe case_type_name do
          kases.each do |kase|
            kase.each do |case_name, case_data|
              it "matches #{case_name}" do
                JsonApi::Parameters.ensure_underscore_translation = true

                input, predicted_output = case_data

                translated_input = described_class.new.jsonapify(input)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])

                JsonApi::Parameters.ensure_underscore_translation = false
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
                JsonApi::Parameters.ensure_underscore_translation = true

                input, predicted_output = case_data
                input = ActionController::Parameters.new(input)

                translated_input = described_class.new.jsonapify(input)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])

                JsonApi::Parameters.ensure_underscore_translation = false
              end
            end
          end
        end
      end
    end

    describe 'camelCased parameters' do
      JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
        describe case_type_name do
          kases.each do |kase|
            kase.each do |case_name, case_data|
              it "matches #{case_name}" do
                JsonApi::Parameters.ensure_underscore_translation = true

                input, predicted_output = case_data
                input[:data][:type] = input[:data][:type].camelize
                input = input.deep_transform_keys { |key| key.to_s.camelize.to_sym }
                input = ActionController::Parameters.new(input)

                translated_input = described_class.new.jsonapify(input)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])

                JsonApi::Parameters.ensure_underscore_translation = false
              end
            end
          end
        end
      end
    end

    describe 'dasherized parameters' do
      JsonApi::Parameters::Testing::PAIRS.each do |case_type_name, kases|
        describe case_type_name do
          kases.each do |kase|
            kase.each do |case_name, case_data|
              it "matches #{case_name}" do
                JsonApi::Parameters.ensure_underscore_translation = true

                input, predicted_output = case_data
                input[:data][:type] = input[:data][:type].dasherize
                input = input.deep_transform_keys { |key| key.to_s.dasherize.to_sym }
                input = ActionController::Parameters.new(input)

                translated_input = described_class.new.jsonapify(input)
                expect(HashDiff.diff(translated_input, predicted_output)).to eq([])

                JsonApi::Parameters.ensure_underscore_translation = false
              end
            end
          end
        end
      end
    end
  end
end
