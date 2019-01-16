require 'rails_helper'

describe AuthorsController, type: :controller do
  describe 'create' do
    it 'creates an author' do
      params = {
        data: {
          type: 'authors',
          attributes: {
            name: 'John Doe'
          }
        }
      }

      post :create, params: params

      expect(jsonapi_response).to eq(
        data: {
          id: '1',
          type: 'author',
          attributes: {
            name: 'John Doe'
          },
          relationships: {
            posts: {
              data: []
            }
          }
        }
      )
    end

    it 'creates an author with posts' do
      params = {
        data: {
          type: 'authors',
          attributes: {
            name: 'John Doe'
          },
          relationships: {
            posts: {
              data: [
                {
                  id: '123',
                  type: 'post'
                }
              ]
            }
          }
        },
        included: [
          {
            type: 'post',
            id: '123',
            attributes: {
              title: 'Some title',
              body: 'Some body that I used to love'
            }
          }
        ]
      }

      post :create, params: params

      expect(jsonapi_response[:data]).to eq(
        id: '2',
        type: 'author',
        attributes: {
          name: 'John Doe'
        },
        relationships: {
          posts: {
            data: [
              {
                id: '1',
                type: 'post'
              }
            ]
          }
        }
      )
    end
  end
end
