module JsonApi
  module Parameters
    @ensure_underscore_translation = false

    class << self
      attr_accessor :ensure_underscore_translation
    end
  end
end
