require 'action_controller'

class ActionController::Parameters
  include JsonApi::Parameters

  def to_jsonapi!
    new jsonapify(self)
  end
end
