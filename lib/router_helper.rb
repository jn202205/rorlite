require 'active_support/inflector'

module RouteHelper
  def link_to(text, path, options={})

    options = {
      method: :get,
    }.merge!(options)

    html = <<-HTML
<a href='#{path}'>#{text}</a>
    HTML
    html
  end

  def button_to(name, action, options={})
    options = {
      method: :post
    }.merge!(options)

    html= <<-HTML
<form action='#{action}' method='#{options[:method].to_s}'>
  <input type='submit' value='#{name}'/>
</form>
    HTML
    html.html_safe
  end

  def generate_collection_helper(controller_class)
    name = model_name(controller_class)
    controller_class.send(:define_method, "#{name}s_url") { "/#{name}s" }
  end

  def generate_new_helper(controller_class)
    name = model_name(controller_class)
    controller_class.send(:define_method, "new_#{name}_url") { "/#{name}s/new" }
  end

  def generate_edit_helper(controller_class)
    name = model_name(controller_class)
    controller_class.send(:define_method, "edit_#{name}_url") do |arg|
      "/#{name}s/#{arg.id}/edit"
    end
  end

  def generate_instance_helper(controller_class)
    name = model_name(controller_class)
    controller_class.send(:define_method, "#{name}_url") do |arg|
      "/#{name}s/#{arg[:id]}"
    end
  end

  def model_name(controller_class)
    "#{controller_class.to_s.gsub(/Controller/, '').downcase.singularize}"
  end
end
