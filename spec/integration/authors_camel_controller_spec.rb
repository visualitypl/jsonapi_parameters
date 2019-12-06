require 'rails_helper'

describe AuthorsCamelController, type: :controller do
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
            scissors: { data: nil },
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
              body: 'Some body that I used to love',
              categoryName: 'Some category'
            }
          }
        ]
      }

      post :create, params: params

      expect(jsonapi_response[:data]).to eq(
        id: '1',
        type: 'author',
        attributes: {
          name: 'John Doe'
        },
        relationships: {
          scissors: { data: nil },
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
      expect(Post.find(1).category_name).to eq('Some category')
    end
  end
end
