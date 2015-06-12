require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/db_connection'
require_relative '../lib/sql_object'
require_relative '../app/models/cat'
require_relative '../app/models/status'
require_relative '../app/models/human'
require_relative '../app/controllers/cats_controller.rb'
require_relative '../app/controllers/statuses_controller.rb'

DBConnection.reset

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  post Regexp.new("^/cats$"), CatsController, :create
  get Regexp.new("^/cats/(?<id>\\d+)$"), CatsController, :show
  get Regexp.new("^/cats/new$"), CatsController, :new
  get Regexp.new("^/statuses$"), StatusesController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
