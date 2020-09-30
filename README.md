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


## Relationships

JsonApi::Parameters supports ActiveRecord relationship parameters, including [nested attributes](https://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html).

Relationship parameters are being read from two optional trees:  

* `relationships`,
* `included`

If you provide any related resources in the `relationships` table, this gem will also look for corresponding, `included` resources and their attributes. Thanks to that this gem supports nested attributes, and will try to translate these included resources and pass them along.

For more examples take a look at [Relationships](https://github.com/visualitypl/jsonapi_parameters/wiki/Relationships) in the wiki documentation.

If you need custom relationship handling (for instance, if you have a relationship named `scissors` that is plural, but it actually is a single entity), you can use Handlers to define appropriate behaviour.

Read more at [Relationship Handlers](https://github.com/visualitypl/jsonapi_parameters/wiki/Relationship-handlers).
 
## Mime Type

As [stated in the JSON:API specification](https://jsonapi.org/#mime-types) correct mime type for JSON:API input should be [`application/vnd.api+json`](http://www.iana.org/assignments/media-types/application/vnd.api+json). 

This gem's intention is to make input consumption as easy as possible. Hence, it [registers this mime type for you](lib/jsonapi_parameters/core_ext/action_dispatch/http/mime_type.rb).

## Stack limit

In theory, any payload may consist of infinite amount of relationships (and so each relationship may have its own, included, infinite amount of nested relationships).
Because of that, it is a potential vector of attack. 

For this reason we have introduced a default limit of stack levels that JsonApi::Parameters will go down through while parsing the payloads. 

This default limit is 3, and can be overwritten by specifying the custom limit. When the limit is exceeded, a `StackLevelTooDeepError` is risen.

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

## Validations

JsonApi::Parameters is validating your payloads **ONLY** when an error occurs. **This means that unless there was an exception, your payload will not be validated.** 

Reason for that is we prefer to avoid any performance overheads, and in most cases the validation errors will only be useful in the development environments, and mostly in the early parts of the implementation process. Our decision was to leave the validation to happen only in case JsonApi::Parameters failed to accomplish its task. 

The validation happens with the use of jsonapi.org's JSON schema draft 6, available [here](https://jsonapi.org/faq/#is-there-a-json-schema-describing-json-api), and a gem called [JSONSchemer](https://github.com/davishmcclurg/json_schemer).

If you would prefer to suppress validation errors, you can do so by declaring it globally in your application: 

```ruby
# config/initializers/jsonapi_parameters.rb

JsonApi::Parameters.suppress_schema_validation_errors = true
```

If you would prefer to prevalidate every payload _before_ attempting to fully parse it, you can do so by enforcing prevalidation: 

```ruby
# config/initializers/jsonapi_parameters.rb

JsonApi::Parameters.enforce_schema_prevalidation = true
```

It is important to note that setting suppression and prevalidation is exclusive. If both settings are set to `true` no prevalidation will happen.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
