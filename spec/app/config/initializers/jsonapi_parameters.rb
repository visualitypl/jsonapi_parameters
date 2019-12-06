require 'jsonapi_parameters'

JsonApi::Parameters::Handlers.add_handler(:scissors_handler, ->(k, v, incl) {
  if v.nil?
    return ["#{k}_id", v]
  end

  _, value = JsonApi::Parameters::Handlers.handlers[:to_one].call(k, v, incl)

  ['scissors_attributes', value]
})
JsonApi::Parameters::Handlers.set_resource_handler(:scissors, :scissors_handler)
