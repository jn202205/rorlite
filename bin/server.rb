require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/db_connection'
require_relative '../lib/sql_object'
require_relative '../app/models/cat'
require_relative '../app/models/status'

DBConnection.reset

class StatusesController < ControllerBase
  def index
    @statuses = Status.all
    render :index
  end
end

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render(:index)
  end

  def new
    @cat = Cat.new
    render(:new)
  end

  def create
    @cat = Cat.new
    render(:new)
  end

  def show
    @cat = Cat.find(@params[:id])
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<id>\\d+)$"), CatsController, :show
  get Regexp.new("^/statuses$"), StatusesController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
