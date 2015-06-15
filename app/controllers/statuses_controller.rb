require_relative '../../lib/controller_base'

class StatusesController < ControllerBase
  def new
    @status = Status.new
    render :new
  end

  def create
    @status = Status.new(params['status'])
    if @status.save
      redirect_to cat_path(@status.cat.id)
    else
      render :new
    end
  end
end
