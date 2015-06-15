require_relative '../../lib/controller_base'

class CatsController < ControllerBase
  def index
    @cats = Cat.all
  end

  def new
    @cat = Cat.new
    render(:new)
  end

  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      redirect_to cats_path
    else
      render :new
    end
  end

  def show
    @cat = Cat.find(@params['id'].to_i)
    if @cat
      render(:show)
    else
      redirect_to(:index)
    end
  end
end
