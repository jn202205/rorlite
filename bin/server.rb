require 'webrick'
require_relative '../lib/controller_base'

class CatsController < ControllerBase
  def go
    if @req.path == "/cats"
      render :index
    else
      redirect_to("/cats")
    end
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  CatsController.new(req, res).go
end

trap('INT') { server.shutdown }
server.start
