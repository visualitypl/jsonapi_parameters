require 'action_controller'

class ActionController::Parameters
  include JsonApi::Parameters

  def to_jsonapi(*args)
    warn "WARNING: #to_jsonapi method is deprecated. Please use #from_jsonapi instead.\n#{caller(1..1).first}"

    from_jsonapi(*args)
  end

  def from_jsonapi(naming_convention = :snake)
    @from_jsonapi ||= self.class.new jsonapify(self, naming_convention: naming_convention)
  end
end
