class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    !!(pattern =~ req.path) && req.request_method.downcase.to_sym == http_method
  end

  def run(req, res)
    matches = pattern.match(req.path)
    route_params = Hash[matches.names.zip(matches.captures)]
    controller_class.new(req, res, route_params).invoke_action(action_name)
  end
end
