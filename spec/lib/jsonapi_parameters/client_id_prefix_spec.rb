require 'spec_helper'

####
# Sample klass
####
class Translator
  include JsonApi::Parameters
end

describe Translator do # rubocop:disable RSpec/FilePath
  context 'when client id prefix is not set' do
    it 'does not ignore any ID sent by the client' do
      input = {
        data: {
          type: 'photos',
          attributes: {
            title: 'Ember Hamster',
            src: 'http://example.com/images/productivity.png'
          },
          relationships: {
            photographers: {
              data: [
                {
                  type: 'people',
                  id: 9
                },
                {
                  type: 'people',
                  id: 10
                },
                {
                  type: 'people',
                  id: 'client_id_new_person'
                }
              ]
            }
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
          },
          {
            type: 'people',
            id: 'client_id_new_person',
            attributes: {
              name: 'New guy'
            }
          }
        ]
      }

      predicted_output = {
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
            },
            {
              id: 'client_id_new_person',
              name: 'New guy'
            }
          ]
        }
      }

      translated_input = described_class.new.jsonapify(input)
      expect(HashDiff.diff(translated_input, predicted_output)).to eq([])
    end
  end

  context 'when client id prefix is set' do
    it 'ignores IDs with client id prefix' do
      JsonApi::Parameters.client_id_prefix = 'client_id_'

      input = {
        data: {
          type: 'photos',
          attributes: {
            title: 'Ember Hamster',
            src: 'http://example.com/images/productivity.png'
          },
          relationships: {
            photographers: {
              data: [
                {
                  type: 'people',
                  id: 9
                },
                {
                  type: 'people',
                  id: 10
                },
                {
                  type: 'people',
                  id: 'client_id_new_person'
                }
              ]
            }
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
          },
          {
            type: 'people',
            id: 'client_id_new_person',
            attributes: {
              name: 'New guy'
            }
          }
        ]
      }

      predicted_output = {
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
            },
            {
              name: 'New guy'
            }
          ]
        }
      }

      translated_input = described_class.new.jsonapify(input)
      expect(HashDiff.diff(translated_input, predicted_output)).to eq([])

      JsonApi::Parameters.client_id_prefix = nil
    end
  end
end
