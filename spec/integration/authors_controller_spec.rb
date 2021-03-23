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

      post_with_rails_fix :create, params: params

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
            },
            scissors: { data: nil }
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
              category_name: 'Some category'
            }
          }
        ]
      }

      post_with_rails_fix :create, params: params

      expect(jsonapi_response[:data]).to eq(
        id: '1',
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
          },
          scissors: { data: nil }
        }
      )
      expect(Post.find(1).category_name).to eq('Some category')
    end

    it 'creates an author with a post, and then removes all his related posts' do
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
              category_name: 'Some category'
            }
          }
        ]
      }

      post_with_rails_fix :create, params: params

      author_id = jsonapi_response[:data][:id]
      params = {
        id: author_id,
        data: {
          type: 'authors',
          id: author_id,
          relationships: {
            posts: {
              data: []
            }
          }
        }
      }

      patch_with_rails_fix :update, params: params, as: :json

      expect(jsonapi_response[:data][:relationships][:posts][:data]).to eq([])
    end

    it 'creates an author with a pair of sharp scissors' do
      params = {
        data: {
          type: 'authors',
          attributes: {
            name: 'John Doe'
          },
          relationships: {
            scissors: {
              data: {
                id: '123',
                type: 'scissors'
              }
            }
          }
        },
        included: [
          {
            type: 'scissors',
            id: '123',
            attributes: {
              sharp: true
            }
          }
        ]
      }

      post_with_rails_fix :create, params: params

      expect(jsonapi_response[:data]).to eq(
        id: '1',
        type: 'author',
        attributes: {
          name: 'John Doe'
        },
        relationships: {
          posts: { data: [] },
          scissors: {
            data: {
              id: '1',
              type: 'scissors'
            }
          }
        }
      )
      expect(Scissors.find(1).sharp).to eq(true)
    end
  end
end
