# JsonApi::Parameters
Simple [JSON:API](https://jsonapi.org/) compliant parameters translator.

[![Gem Version](https://badge.fury.io/rb/jsonapi_parameters.svg)](https://badge.fury.io/rb/jsonapi_parameters)
[![Maintainability](https://api.codeclimate.com/v1/badges/84fd5b548eea8d7e18af/maintainability)](https://codeclimate.com/github/visualitypl/jsonapi_parameters/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/84fd5b548eea8d7e18af/test_coverage)](https://codeclimate.com/github/visualitypl/jsonapi_parameters/test_coverage)
[![CircleCI](https://circleci.com/gh/visualitypl/jsonapi_parameters.svg?style=svg)](https://circleci.com/gh/visualitypl/jsonapi_parameters)

[Documentation](https://github.com/visualitypl/jsonapi_parameters/wiki)

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

For more examples take a look at [Relationships](https://github.com/visualitypl/jsonapi_parameters/wiki/Relationships) in the wiki documentation.

##### Client generated IDs

You can specify client_id_prefix:
```
JsonApi::Parameters.client_id_prefix = 'client_'
```

Default client_id_prefix is `cid_`

All IDs starting with `JsonApi::Parameters.client_id_prefix` will be removed from params.

In case of creating new nested resources, client will need to generate IDs sent in `relationships` and `included` parts of request.

```
{
  "type": "multitracks",
  "attributes": {
    "title": "Multitrack"
  },
  "relationships": {
    "tracks": {
       "data": [
        {
          "type": "tracks",
          "id": "cid_new_track"                 // Client ID for new resources -> needs to match ID in included below
        }
       ]
    }
  },
  "included": [
    {
      "id": "cid_new_track",                    // Client ID for new resources -> needs to match ID in relationships below
      "type": "tracks",
      "attributes": {
        "name": "Drums"
       }
    }
  ]
}
```

```
params.from_jsonapi

{
  "multitrack" => {
    "title" => "Multitrack",
    "tracks_attributes" => {
      "0" =>  {                                 // No ID is present, so ActiveRecord#create correctly creates the new instance
         "name" => "Drums"
      }
    }
  }
}
```

In case of updating existing nested resources and creating new ones in the same request, client needs to generate IDs for new resources and use existing ones for existing resources. Client IDs will be removed from params.


```
{
  "type": "multitracks",
  "attributes": {
    "title": "Multitrack"
  },
  "relationships": {
    "tracks": {
       "data": [
        {
          "type": "tracks",
          "id": "123"                           // Existing ID for existing resources
        },
        {
          "type": "tracks",
          "id": "cid_new_track"                 // Client ID for new resources -> needs to match ID in included below
        }
       ]
    }
  },
  "included": [
    {
      "id": "123",                              // Existing ID for existing resources
      "type": "tracks",
      "attributes": {
        "name": "Piano"
       }
    },
    {
      "id": "cid_new_track",                    // Client ID for new resources -> needs to match ID in relationships below
      "type": "tracks",
      "attributes": {
        "name": "Drums"
       }
    }
  ]
}
```

```
params.from_jsonapi

{
  "multitrack" => {
    "title" => "Multitrack",
    "tracks_attributes" => {
      "0" =>  {
         "id" => "123",
         "name" => "Piano"
      },
      "1" =>  {                                 // No ID is present, so ActiveRecord#update correctly creates the new instance
         "name" => "Drums"
      }
    }
  }
}
```


Translate


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

## Mime Type

As [stated in the JSON:API specification](https://jsonapi.org/#mime-types) correct mime type for JSON:API input should be [`application/vnd.api+json`](http://www.iana.org/assignments/media-types/application/vnd.api+json).

This gem's intention is to make input consumption as easy as possible. Hence, it [registers this mime type for you](lib/jsonapi_parameters/core_ext/action_dispatch/http/mime_type.rb).

## Stack limit

In theory, any payload may consist of infinite amount of relationships (and so each relationship may have its own, included, infinite amount of nested relationships).
Because of that, it is a potential vector of attack.

For this reason we have introduced a default limit of stack levels that JsonApi::Parameters will go down through while parsing the payloads.

This default limit is 3, and can be overwritten by specifying the custom limit.

#### Ruby
```ruby
class Translator
    include JsonApi::Parameters
end

translator = Translator.new

translator.jsonapify(custom_stack_limit: 4)

# OR

translator.stack_limit = 4
translator.jsonapify.(...)
```

#### Rails
```ruby
def create_params
    params.from_jsonapi(custom_stack_limit: 4).require(:user).permit(
        entities_attributes: { subentities_attributes: { ... } }
    )
end

# OR

def create_params
    params.stack_level = 4

    params.from_jsonapi.require(:user).permit(entities_attributes: { subentities_attributes: { ... } })
ensure
    params.reset_stack_limit!
end
```

## Customization

If you need custom relationship handling (for instance, if you have a relationship named `scissors` that is plural, but it actually is a single entity), you can use Handlers to define appropriate behaviour.

Read more at [Relationship Handlers](https://github.com/visualitypl/jsonapi_parameters/wiki/Relationship-handlers).

## Team

Project started by [Jasiek Matusz](https://github.com/Marahin).

Currently, jsonapi_parameters is maintained by Visuality's [Open Source Commitee](https://www.visuality.pl/open-source).

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
