require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './params'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)
    @already_built_response = false
  end

  def already_built_response?
    @already_built_response
  end

  def render_content(content, content_type)
    raise 'Already built response' if already_built_response?
    res.body = content
    res.content_type = content_type
    session.store_session(res)
    @already_built_response = true

    nil
  end

  def redirect_to(url)
    raise 'Already rendered response' if already_built_response?
    res.status = 302
    res.header['location'] = url
    session.store_session(res)
    @already_built_response = true

    nil
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template = File.read("app/views/#{controller_name}/#{template_name}.html.erb")
    content = ERB.new(template).result(binding)
    render_content(content, 'text/html')
  end

  def session
    @session ||= Session.new(req)
  end

  private
  attr_writer :req, :res

end
