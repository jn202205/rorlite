require_relative '../../lib/controller_base'

class HumansController < ControllerBase
  def index
    @humans = Human.all
  end

  def show
    @human = Human.find(params['id'].to_i)
    render :show
  end

  def new
    @human = Human.new
    render(:new)
  end

  def create
    @human = Human.new(params["human"])
    if @human.save
      redirect_to humans_path
    else
      render :new
    end
  end
end
