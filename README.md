# JsonApi::Parameters
Simple [JSON:API](https://jsonapi.org/) compliant parameters translator.

[![Gem Version](https://badge.fury.io/rb/jsonapi_parameters.svg)](https://badge.fury.io/rb/jsonapi_parameters)
[![Maintainability](https://api.codeclimate.com/v1/badges/84fd5b548eea8d7e18af/maintainability)](https://codeclimate.com/github/visualitypl/jsonapi_parameters/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/84fd5b548eea8d7e18af/test_coverage)](https://codeclimate.com/github/visualitypl/jsonapi_parameters/test_coverage)

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

This gems intention is to make input consumption as easy as possible. Hence, it [registers this mime type for you](lib/jsonapi_parameters/core_ext/action_dispatch/http/mime_type.rb). 

## Customization

If you need custom relationship handling (for instance, if you have a relationship named `scissors` that is plural, but it actually is a single entity), you can use Handlers to define appropriate behaviour.

Read more at [Relationship Handlers]()

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
