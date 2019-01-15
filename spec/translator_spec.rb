require 'spec_helper'
require 'pry'
####
# Input-Output translator test cases
####
test_cases = {
  'POST create payloads' => [
    'single root, single attribute' => [
      { data: { type: 'tests', attributes: { name: 'test name' } } },
      { test: { name: 'test name' } }
    ],
    'single root, multiple attributes' => [
      { data: { type: 'tests', attributes: { name: 'test name', age: 21 } } },
      { test: { name: 'test name', age: 21 } }
    ],
    'https://jsonapi.org/format/#crud example' => [
      {
        data: {
          type: 'photos',
          attributes: {
            title: 'Ember Hamster',
            src: 'http://example.com/images/productivity.png'
          },
          relationships: {
            photographer: {
              data: {
                type: 'people',
                id: 9
              }
            }
          }
        }
      },
      {
        photo: {
          title: 'Ember Hamster',
          src: 'http://example.com/images/productivity.png',
          photographer_id: 9
        }
      }
    ],
    'https://jsonapi.org/format/#crud example (modified, multiple photographers)' => [
      {
        data: {
          type: 'photos',
          attributes: {
            title: 'Ember Hamster',
            src: 'http://example.com/images/productivity.png'
          },
          relationships: {
            photographers: [
              {
                data: {
                  type: 'people',
                  id: 9
                }
              },
              {
                data: {
                  type: 'people',
                  id: 10
                }
              }
            ]
          }
        },
        included: [
          {
            type: 'people',
            id: 10,
            attributes: {
              name: 'Some guy'
            }
          },
          {
            type: 'people',
            id: 9,
            attributes: {
              name: 'Some other guy'
            }
          }
        ]
      },
      {
        photo: {
          title: 'Ember Hamster',
          src: 'http://example.com/images/productivity.png',
          photographers_attributes: [
            {
              id: 9,
              name: 'Some other guy'
            },
            {
              id: 10,
              name: 'Some guy'
            }
          ]
        }
      }
    ]
  ]
}


####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe Translator do
  describe 'plain hash parameters' do
    test_cases.each do |case_type_name, kases|
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
    test_cases.each do |case_type_name, kases|
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
