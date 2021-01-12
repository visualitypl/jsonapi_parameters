module JsonApi
  module Parameters
    @ensure_underscore_translation = false
    @client_id_prefix = 'cid_'

    class << self
      attr_accessor :ensure_underscore_translation
      attr_accessor :client_id_prefix
    end
  end
end
