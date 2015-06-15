require_relative '../../lib/controller_base'

class HousesController < ControllerBase
  def index
    @houses = House.all
  end

  def new
    @house = House.new
    render(:new)
  end

  def create
    @house = House.new(params["house"])
    if @house.save
      redirect_to houses_path
    else
      render :new
    end
  end

  def show
    @house = House.find(params['id'].to_i)
    render :show
  end
end
