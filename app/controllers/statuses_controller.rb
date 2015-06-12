require_relative '../../lib/controller_base'

class StatusesController < ControllerBase
  def index
    @statuses = Status.all
    render :index
  end
end
