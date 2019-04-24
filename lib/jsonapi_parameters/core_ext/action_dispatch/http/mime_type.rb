require 'action_dispatch/http/mime_type'

API_MIME_TYPES = %w(
  application/vnd.api+json
  text/x-json
  application/json
).freeze

Mime::Type.register API_MIME_TYPES.first, :json, API_MIME_TYPES
