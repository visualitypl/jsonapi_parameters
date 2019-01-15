require 'action_controller'

class ActionController::Parameters
  include JsonApi::Parameters

  def to_jsonapi
    @to_jsonapi ||= self.class.new jsonapify(self)
  end
end
