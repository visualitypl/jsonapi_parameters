module JsonApi
  module Parameters
    @ensure_underscore_translation = false
    @client_id_prefix = 'client_id'

    class << self
      attr_accessor :ensure_underscore_translation
      attr_accessor :client_id_prefix
    end
  end
end
