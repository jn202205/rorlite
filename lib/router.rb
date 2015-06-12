require_relative './route'
require_relative './router_helper'

class Router
  include RouteHelper
  attr_reader :routes

  def initialize
    @routes = []
  end

  # adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
    case action_name
    when :index, :create
      generate_collection_helper(controller_class)
    when :new
      generate_new_helper(controller_class)
    when :put
      generate_edit_helper(controller_class)
    when :show, :update, :destroy
      generate_instance_helper(controller_class)
    end
  end

  # evaluate the proc in the context of the instance
  def draw(&proc)
    instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.find { |route| route.matches?(req) }
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    route = match(req)
    route.nil? ? res.status = 404 : route.run(req, res)
  end
end
