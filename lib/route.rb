class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
    add_route_helpers
  end

  def add_route_helpers
    case action_name
    when :index, :create
      generate_collection_helper
    when :new
      generate_new_helper
    when :edit
      generate_edit_helper
    when :show, :update, :destroy
      generate_instance_helper
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

  def generate_collection_helper
    name = model_name
    controller_class.send(:define_method, "#{name.pluralize}_path") { "/#{name.pluralize}" }
  end

  def generate_new_helper
    name = model_name
    controller_class.send(:define_method, "new_#{name}_path") { "/#{name.pluralize}/new" }
  end

  def generate_edit_helper
    name = model_name
    controller_class.send(:define_method, "edit_#{name}_path") do |arg|
      "/#{name}s/#{arg}/edit"
    end
  end

  def generate_instance_helper
    name = model_name
    controller_class.send(:define_method, "#{name}_path") do |arg|
      "/#{name}s/#{arg[:id]}"
    end
  end

  def model_name
    "#{controller_class.to_s.gsub(/Controller/, '').downcase.singularize}"
  end
end
