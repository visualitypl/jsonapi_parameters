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
    ],
    'PATCH update payloads' => [
      'https://jsonapi.org/format/#crud example (modified, multiple photographers)' => [
        {
          data: {
            type: 'photos',
            attributes: {
              id: 2,
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
            id: 2,
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
