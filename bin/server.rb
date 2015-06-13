require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/sql_object'
application_root = File.realpath(File.dirname(File.absolute_path(__FILE__)) + '/..')
Dir.glob(application_root + '/app/controllers/*.rb', &method(:require))
Dir.glob(application_root + '/app/models/*.rb', &method(:require))

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
