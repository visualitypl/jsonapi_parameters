module JsonApi::Parameters::Testing
  PAIRS = {
    'POST create payloads' => [
      'single root, single attribute' => [
        { data: { type: 'tests', attributes: { name: 'test name' } } },
        { test: { name: 'test name' } }
      ],
      'single root, multiple attributes' => [
        { data: { type: 'tests', attributes: { name: 'test name', age: 21 } } },
        { test: { name: 'test name', age: 21 } }
      ],
      'single root, single relationship, multiple related resources' => [
        {
          :data => {
            :type => "contract",
            :attributes => {
              :total_amount => "40.0",
              :start_date => "2018-10-18"
            },
            :relationships => {
              :products => {
                :data => [
                  {
                    :id => "4", :type => "product"
                  }, {
                    :id => "5", :type => "product"
                  }, {
                    :id => "6", :type => "product"
                  }
                ]
              },
              :customer => {
                :data => {
                  :id => "1", :type => "customer"
                }
              }
            }
          },
          :included => [
            {
              :id => "4",
              :type => "product",
              :attributes => {
                :category => "first_category",
                :amount => "15.0",
                :name => "First product",
                :note => ""
              }
            },
            {
              :id => "5",
              :type => "product",
              :attributes => {
                :category => "first_category",
                :amount => "10.0",
                :name => "Second Product",
              }
            },
            {
              :id => "6",
              :type => "product",
              :attributes => {
                :category => "second_category",
                :amount => "15.0",
                :name => "Third Product",
              }
            }
          ]
        },
        {
          contract: {
            start_date: '2018-10-18',
            total_amount: '40.0',
            customer_id: '1',
            products_attributes: [
              {
                id: '4',
                :category => "first_category",
                :amount => "15.0",
                :name => "First product",
                note: ''
              },
              {
                id: '5',
                :category => "first_category",
                :amount => "10.0",
                :name => "Second Product"
              },
              {
                id: '6',
                :category => "second_category",
                :amount => "15.0",
                :name => "Third Product"
              }
            ]
          }
        }
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
              photographers: {
                data: [
                  {
                    id: 9,
                    type: 'people'
                  },
                  {
                    id: 10,
                    type: 'people'
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
      ],
      'relationships without included (issue #13 - https://github.com/visualitypl/jsonapi_parameters/issues/13)' => [
        {
          data: {
              type: 'movies',
              attributes: {
                title: 'The Terminator',
                released_at: '1984-10-26',
                runtime: 107,
                content_rating: 'restricted',
                storyline: 'A seemingly indestructible android is sent from 2029 to 1984 to assassinate a waitress, whose unborn son will lead humanity in a war against the machines, while a soldier from that war is sent to protect her at all costs.',
                budget: 6400000
              },
              relationships: {
                genres: {
                  data: [
                    {
                      id: 74, type: 'genres'
                    }
                  ]
                },
                director: {
                  data: {
                    id: 682, type: 'directors'
                  }
                }
              }
            }
        },
        {
          movie: {
            title: 'The Terminator',
            released_at: '1984-10-26',
            runtime: 107,
            content_rating: 'restricted',
            storyline: 'A seemingly indestructible android is sent from 2029 to 1984 to assassinate a waitress, whose unborn son will lead humanity in a war against the machines, while a soldier from that war is sent to protect her at all costs.',
            budget: 6400000,
            director_id: 682,
            genre_ids: [74]
          }
        }
      ]
    ],
    'PATCH update payloads' => [
        'https://jsonapi.org/format/#crud example (modified, multiple photographers)' => [
          {
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
end
