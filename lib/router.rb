require_relative './route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
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

  def resources(controller, options)
    routes = define_routes(controller, options)
    routes.keys.each do |action|
      pattern = replace_url_vars(routes[action][:path])
      add_route(pattern, routes[action][:method], "#{controller}_controller".camelize.constantize, action)
    end
  end

  def define_routes(controller, options)
    routes = {
      index: { path: "/#{controller}", method: :get },
      create: { path: "/#{controller}", method: :post },
      new: { path: "/#{controller}/new", method: :get },
      edit: { path: "/#{controller}/:id/edit", method: :get },
      show: { path: "/#{controller}/:id", method: :get },
      update: { path: "/#{controller}/:id", method: :put },
      destroy: { path: "/#{controller}/:id", method: :delete }
    }

    routes.select! { |action| options[:only].include?(action) } if options[:only]
    routes -= options[:except] if options[:except]
    routes
  end

  def replace_url_vars(path_str)
    if path_str.include?(":id")
      pattern = path_str.gsub!(/(:\w+)[\/]?/) do |match|
        "(?<#{match.gsub(/[:\/]/, "")}>\\d+)#{match[-1] == "/" ? "/" : ""}"
      end
      pattern = Regexp.new("^#{pattern}$")
    else
      pattern = Regexp.new("^#{path_str}$")
    end
    pattern
  end
end
