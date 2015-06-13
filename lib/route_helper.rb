require 'active_support/inflector'

module RouteHelper
  def link_to(name, path, options={})
    "<a href='#{path}'>#{name}</a>"
  end

  def button_to(name, path, options={})
    html= "<form action='#{path}' method='post'>"
    if options[:method]
      html += "<input type='hidden' name='_method' value='#{ options[:method] }'>"
    end
    html += "<input type='submit' value='#{ name }'>"
    html += "</form>"
  end
end
