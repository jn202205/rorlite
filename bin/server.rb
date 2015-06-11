require 'webrick'
require_relative '../lib/controller_base'

class Cat
  attr_reader :name, :owner

  def self.all
    @cat ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def save
    return false unless @name.present? && @owner.present?

    Cat.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end

class CatsController < ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      self.session["count"] ||= 0
      redirect_to("/cats")
    else
      render :new
    end
  end

  def index
    self.session["count"] ||= 0
    self.session["count"] += 1
    @cats = Cat.all
    render :index
  end

  def new
    self.session["count"] ||= 0
    @cat = Cat.new
    render :new
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  case [req.request_method, req.path]
  when ['GET', '/cats'] || ['GET', '/']
    CatsController.new(req, res, {}).index
  when ['POST', '/cats']
    CatsController.new(req, res, {}).create
  when ['GET', '/cats/new']
    CatsController.new(req, res, {}).new
  end
end

trap('INT') { server.shutdown }
server.start
