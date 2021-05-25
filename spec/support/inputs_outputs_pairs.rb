module JsonApi::Parameters::Testing
  PAIRS = {
    'POST create payloads' => [
      { 'single root, single attribute' => [
        { data: { type: 'tests', attributes: { name: 'test name' } } },
        { test: { name: 'test name' } }
      ] },
      { 'single root, client generated id' => [
        { data: { id: 22, type: 'tests', attributes: { name: 'test name' } } },
        { test: { id: 22, name: 'test name' } }
      ] },
      { 'single root, multiple attributes' => [
        { data: { type: 'tests', attributes: { name: 'test name', age: 21 } } },
        { test: { name: 'test name', age: 21 } }
      ] },
      { 'single root, single relationship, multiple related resources' => [
        {
          data: {
            type: "contract",
            attributes: {
              total_amount: "40.0",
              start_date: "2018-10-18"
            },
            relationships: {
              products: {
                data: [
                  {
                    id: "4", type: "product"
                  }, {
                    id: "5", type: "product"
                  }, {
                    id: "6", type: "product"
                  }
                ]
              },
              customer: {
                data: {
                  id: "1", type: "customer"
                }
              }
            }
          },
          included: [
            {
              id: "4",
              type: "product",
              attributes: {
                category: "first_category",
                amount: "15.0",
                name: "First product",
                note: ""
              }
            },
            {
              id: "5",
              type: "product",
              attributes: {
                category: "first_category",
                amount: "10.0",
                name: "Second Product",
              }
            },
            {
              id: "6",
              type: "product",
              attributes: {
                category: "second_category",
                amount: "15.0",
                name: "Third Product",
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
                category: "first_category",
                amount: "15.0",
                name: "First product",
                note: ''
              },
              {
                id: '5',
                category: "first_category",
                amount: "10.0",
                name: "Second Product"
              },
              {
                id: '6',
                category: "second_category",
                amount: "15.0",
                name: "Third Product"
              }
            ]
          }
        }
      ] },
      { 'https://jsonapi.org/format/#crud example' => [
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
      ] },
      { 'https://jsonapi.org/format/#crud example (modified, multiple photographers)' => [
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
      ] },
      { 'relationships without included (issue #13 - https://github.com/visualitypl/jsonapi_parameters/issues/13)' => [
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
      ] },
      { 'relationships with included director (issue #13 - https://github.com/visualitypl/jsonapi_parameters/issues/13)' => [
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
          },
          included: [
            {
              type: 'directors',
              id: 682,
              attributes: {
                name: 'Some guy'
              }
            }
          ]
        },
        {
          movie: {
            title: 'The Terminator',
            released_at: '1984-10-26',
            runtime: 107,
            content_rating: 'restricted',
            storyline: 'A seemingly indestructible android is sent from 2029 to 1984 to assassinate a waitress, whose unborn son will lead humanity in a war against the machines, while a soldier from that war is sent to protect her at all costs.',
            budget: 6400000,
            director_attributes: { id: 682, name: 'Some guy' },
            genre_ids: [74]
          }
        }
      ] },
      { 'long type name - type casing translation (https://github.com/visualitypl/jsonapi_parameters/pull/31)' => [
        {
          data: {
            type: 'message_board_threads',
            attributes: {
              thread_title: 'Introductory Thread'
            }
          }
        },
        { message_board_thread: { thread_title: 'Introductory Thread' } }
      ] },
      { 'triple-nested payload' => [
        {
          data: {
            type: 'entity',
            relationships: {
              subentity: {
                data: {
                  type: 'entity',
                  id: 1
                }
              }
            }
          },
          included: [
            {
              id: 1, type: 'entity', relationships: {
              subentity: {
                data: {
                  type: 'entity',
                  id: 2
                }
              }
            }
            },
            {
              id: 2, type: 'entity', relationships: {
              subentity: {
                data: {
                  type: 'entity',
                  id: 3
                }
              }
            }
            }
          ]
        },
        {
          entity: {
            subentity_attributes: {
              id: 1,
              subentity_attributes: {
                id: 2,
                subentity_id: 3
              }
            }
          }
        }
      ] }
    ],
    'PATCH update payloads' => [
      { 'https://jsonapi.org/format/#crud example (modified, multiple photographers)' => [
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
      ] },
      { 'https://jsonapi.org/format/#crud example (added new, modified existing photographers)' => [
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
                  },
                  {
                    type: 'people',
                    id: 'cid_new_person'
                  },
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
              id: 'cid_new_person',
              attributes: {
                name: 'New guy'
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
              },
              {
                name: 'New guy'
              }
            ]
          }
        }
      ] },
      { 'https://jsonapi.org/format/#crud-updating-to-many-relationships example (removal, all photographers)' => [
        {
          data: {
            type: 'photos',
            attributes: {
              title: 'Ember Hamster',
              src: 'http://example.com/images/productivity.png'
            },
            relationships: {
              photographers: {
                data: []
              }
            }
          }
        },
        {
          photo: {
            title: 'Ember Hamster',
            src: 'http://example.com/images/productivity.png',
            photographer_ids: []
          }
        }
      ] },
      { 'https://jsonapi.org/format/#crud-updating-to-one-relationships example (removal, single owner)' => [
        {
          data: {
            type: 'account',
            attributes: {
              name: 'Bob Loblaw',
              profile_url: 'http://example.com/images/no-nonsense.png'
            },
            relationships: {
              owner: {
                data: nil
              }
            }
          }
        },
        {
          account: {
            name: 'Bob Loblaw',
            profile_url: 'http://example.com/images/no-nonsense.png',
            owner_id: nil
          }
        }
      ] },
      { 'https://github.com/pstrzalk case of emptying has_many relationship (w/ empty included)' => [
        {
          data: {
            type: 'users',
            attributes: {
              name: 'Adam Joe'
            },
            relationships: {
              practice_areas: {
                data: []
              }
            },
            included: []
          }
        },
        {
          user: {
            name: 'Adam Joe', practice_area_ids: [],
          }
        }
      ] },
      { 'https://github.com/pstrzalk case of emptying has_many relationship (w/o included)' => [
        {
          data: {
            type: 'users',
            attributes: {
              name: 'Adam Joe'
            },
            relationships: {
              practice_areas: {
                data: []
              }
            }
          }
        },
        {
          user: {
            name: 'Adam Joe', practice_area_ids: [],
          }
        }
      ] },
      { 'os-15 case - nested relationship within a relationship' => [
        {
          data: {
            id: "1", type: "contacts",
            relationships: {
              contacts_employment_statuses: {
                data: [
                  { id: 444, type: "contact_employment_statuses" }
                ]
              }
            }
          },
          included: [
            {
              id: 444, type: "contact_employment_statuses",
              attributes: {
                involved_in: true, receives_submissions: false
              },
              relationships: {
                employment_status: { data: { id: 110, type: "employment_statuses" } }
              }
            }
          ]
        },
        {
          contact: {
            id: "1",
            contacts_employment_statuses_attributes: [
              { id: 444, involved_in: true, receives_submissions: false, employment_status_id: 110 }
            ]
          }
        }
      ] },
      { 'os-15 case extended - nested relationship within a to-many relationship, with an included object' => [
        {
          data: {
            id: "1", type: "contacts",
            relationships: {
              contacts_employment_statuses: {
                data: [
                  { id: 444, type: "contact_employment_statuses" }
                ]
              }
            }
          },
          included: [
            {
              id: 444, type: "contact_employment_statuses",
              attributes: {
                involved_in: true, receives_submissions: false
              },
              relationships: {
                employment_status: { data: { id: 110, type: "employment_statuses" } }
              }
            },
            {
              id: 110, type: "employment_statuses",
              attributes: {
                status: "yes",
              }
            }
          ]
        },
        {
          contact: {
            id: "1",
            contacts_employment_statuses_attributes: [
              { id: 444, involved_in: true, receives_submissions: false, employment_status_attributes: { id: 110, status: "yes" } }
            ]
          }
        }
      ] },
      { 'os-15 case extended - nested relationship within a to-many relationship, with a to-many relationship' => [
        {
          data: {
            id: "1", type: "contacts",
            relationships: {
              contacts_employment_statuses: {
                data: [
                  { id: 444, type: "contact_employment_statuses" }
                ]
              }
            }
          },
          included: [
            {
              id: 444, type: "contact_employment_statuses",
              attributes: {
                involved_in: true, receives_submissions: false
              },
              relationships: {
                employment_status: { data: [{ id: 110, type: "employment_statuses" }] }
              }
            },
          ]
        },
        {
          contact: {
            id: "1",
            contacts_employment_statuses_attributes: [
              { id: 444, involved_in: true, receives_submissions: false, employment_status_ids: [110] }
            ]
          }
        }
      ] },
      { 'os-15 case extended - nested relationship within a to-one relationship' => [
        {
          data: {
            id: "1", type: "contacts",
            relationships: {
              contacts_employment_status: {
                data: { id: 444, type: "contact_employment_status" }
              }
            }
          },
          included: [
            {
              id: 444, type: "contact_employment_status",
              attributes: {
                involved_in: true, receives_submissions: false
              },
              relationships: {
                employment_status: { data: { id: 110, type: "employment_statuses" } }
              }
            }
          ]
        },
        {
          contact: {
            id: "1",
            contacts_employment_status_attributes: {
              id: 444, involved_in: true, receives_submissions: false, employment_status_id: 110
            }
          }
        }
      ] },
    ]
  }
end
