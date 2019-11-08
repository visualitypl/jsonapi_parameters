# JsonApi::Parameters
Simple JSON:API compliant parameters translator.

[![Gem Version](https://badge.fury.io/rb/jsonapi_parameters.svg)](https://badge.fury.io/rb/jsonapi_parameters)
[![Maintainability](https://api.codeclimate.com/v1/badges/84fd5b548eea8d7e18af/maintainability)](https://codeclimate.com/github/visualitypl/jsonapi_parameters/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/84fd5b548eea8d7e18af/test_coverage)](https://codeclimate.com/github/visualitypl/jsonapi_parameters/test_coverage)

#### The problem

JSON:API standard specifies not only responses (that can be handled nicely, using gems like [fast_jsonapi from Netflix](https://github.com/Netflix/fast_jsonapi)), but also the request structure. 

#### The solution

As we couldn't find any gem that would make it easier in Rails to use these structures, we decided to create something that will work for us - a translator that transforms JSON:API compliant request parameter strucure into a Railsy structure.

## Usage

### Installation
Add this line to your application's Gemfile:

```ruby
gem 'jsonapi_parameters'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install jsonapi_parameters
```

### Rails

Usually your strong parameters in controller are invoked this way:

```ruby
def create
  model = Model.new(create_params)
  
  if model.save
    ...
  else
    head 500
  end
end

private

def create_params
  params.require(:model).permit(:name)
end
```

With jsonapi_parameters, the difference is just the params:

```ruby
def create_params
  params.from_jsonapi.require(:model).permit(:name)
end
```

#### Relationships

JsonApi::Parameters supports ActiveRecord relationship parameters, including [nested attributes](https://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html).

Relationship parameters are being read from two optional trees:  

* `relationships`,
* `included`

If you provide any related resources in the `relationships` table, this gem will also look for corresponding, `included` resources and their attributes. Thanks to that this gem supports nested attributes, and will try to translate these included resources and pass them along.

##### belongs_to

Passing a resource that is a single entity in relationships tree will make JsonApi::Parameters assume that it is a `belongs_to` relationship. 

###### Without included entity
Example:

```
class Movie < ActiveRecord::Model
    belongs_to :director
end
```

Request body:

```
{
    data: {
        type: 'movies',
        attributes: {
          title: 'The Terminator',
        },
        relationships: {
          director: {
            data: {
              id: 682, type: 'directors'
            }
          }
        }
    }
}
```

Will translate to:

```
{
  movie: {
    title: 'The Terminator',
    director_id: 682
  }
}
```


###### With included entity:
Example:

```
class Movie < ActiveRecord::Model
    belongs_to :director
    
    accepts_nested_attributes_for :director
end
```

Request body:
```
{
    data: {
        type: 'movies',
        attributes: {
          title: 'The Terminator',
        },
        relationships: {
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
}
```

Will translate to:   
```
{
  movie: {
    title: 'The Terminator',
    director_attributes: { id: 682, name: 'Some guy' }
  }
}
```

##### has_many

Passing a resource that is a an array of entities in relationships tree will make JsonApi::Parameters assume that it is a `has_many` relationship. 

###### Without included entity
Example:

```
class Movie < ActiveRecord::Model
    has_many :genres
end
```

Request body:

```
{
    data: {
        type: 'movies',
        attributes: {
          title: 'The Terminator',
        },
        relationships: {
          genres: {
            data: [{
              id: 1, type: 'genres'
            },
            {
              id: 2, type: 'genres'
            }]
          }
        }
    }
}
```

Will translate to:

```
{
  movie: {
    title: 'The Terminator',
    genre_ids: [1, 2]
  }
}
```


###### With included entity:
Example:

```
class Movie < ActiveRecord::Model
    has_many :genres
    
    accepts_nested_attributes_for :genres
end
```

Request body:
```
{
    data: {
        type: 'movies',
        attributes: {
          title: 'The Terminator',
        },
        relationships: {
          genres: [{
            data: {
              id: 1, type: 'genres'
            }
          }]
        }
    },
    included: [
        {
            type: 'genre',
            id: 1,
            attributes: { 
                name: 'Genre one'
            }
        }
    ]
}
```

Will translate to:   
```
{
  movie: {
    title: 'The Terminator',
    genres_attributes: [{ id: 1, name: 'Genre one' }]
  }
}
```


#### Casing

If the input is in a different convention than `:snake`, you should specify that.
 
 You can do it in two ways: 
 * in an initializer, simply create `initializers/jsonapi_parameters.rb` with contents similar to: 
 ```ruby
 # config/initializers/jsonapi_parameters.rb
  
  JsonApi::Parameters.ensure_underscore_translation = true
 
 ```
 
 * while calling `.from_jsonapi`, for instance: `.from_jsonapi(:camel)`. **The value does not really matter, as anything different than `:snake` will result in deep keys transformation provided by [ActiveSupport](https://apidock.com/rails/v4.1.8/Hash/deep_transform_keys).**

### Plain Ruby / outside Rails

```ruby

params = { # JSON:API compliant parameters here
	# ...
}

class Translator
  include JsonApi::Parameters
end
translator = Translator.new

translator.jsonapify(params)
```

#### Casing

If the input is in a different convention than `:snake`, you should specify that.
 
 You can do it in two ways:
 
 * by a global setting: `JsonApi::Parameters.ensure_underscore_translation = true` 
 * while calling `.jsonapify`, for instance: `.jsonapify(params, naming_convention: :camel)`. **The value does not really matter, as anything different than `:snake` will result in deep keys transformation provided by [ActiveSupport](https://apidock.com/rails/v4.1.8/Hash/deep_transform_keys).**
 
## Mime Type

As [stated in the JSON:API specification](https://jsonapi.org/#mime-types) correct mime type for JSON:API input should be [`application/vnd.api+json`](http://www.iana.org/assignments/media-types/application/vnd.api+json). 

This gems intention is to make input consumption as easy as possible. Hence, it [registers this mime type for you](lib/jsonapi_parameters/core_ext/action_dispatch/http/mime_type.rb). 

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
