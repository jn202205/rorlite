require_relative '../../lib/controller_base'

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    session['count'] ||= 0
    session['count'] += 1
  end

  def new
    @cat = Cat.new
    render(:new)
  end

  def create
    @human = Human.where(fname: params["cat"]["human"])

    @cat = @owner.new(params["cat"])
    if @cat.save
      redirect_to "/cats"
    else
      render :new
    end
  end

  def show
    @cat = Cat.find(@params[:id])
  end
end
