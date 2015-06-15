require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/sql_object'
application_root = File.realpath(File.dirname(File.absolute_path(__FILE__)) + '/..')
Dir.glob(application_root + '/app/controllers/*.rb', &method(:require))
Dir.glob(application_root + '/app/models/*.rb', &method(:require))

router = Router.new
router.draw do
  root to: "houses#index"
  resources :houses, only: [:index, :show, :new, :create]
  resources :humans, only: [:index, :new, :create, :show]
  resources :cats, only: [:index, :new, :create, :show]
  resources :statuses, only: [:new, :create]
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
