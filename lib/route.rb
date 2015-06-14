require_relative 'route_helper'

class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
    add_route_helpers
  end

  def add_route_helpers
    name = model_name
    plural_name = model_name.pluralize
    case action_name
    when :index, :create
      add_path_method("#{plural_name}_path", "/#{plural_name}")
    when :new
      add_path_method("new_#{name}_path", "/#{plural_name}/new")
    when :edit
      add_path_method("edit_#{name}_path", "/#{plural_name}/:id/edit")
    when :show, :update, :destroy
      add_path_method("#{name}_path", "/#{plural_name}/:id")
    end
  end

  def matches?(req)
    !!(pattern =~ req.path) && req.request_method.downcase.to_sym == http_method
  end

  def run(req, res)
    matches = pattern.match(req.path)
    route_params = Hash[matches.names.zip(matches.captures)]
    controller_class.new(req, res, route_params).invoke_action(action_name)
  end

  private
  def add_path_method(path_name, path)
    RouteHelper.send(:define_method, path_name) do |*args|
      id = args.first.to_s
      if path.include?(':id') && !id.nil?
        path.gsub!(':id', id)
      end
      path
    end
  end

  def model_name
    controller_class.to_s.underscore.gsub('_controller', '').singularize
  end
end
