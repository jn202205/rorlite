class ControllerBase
  attr_reader :req, :res

  def initialize(req, res)
    @req, @res = req, res
    @already_built_response = false
  end

  def already_built_response?
    @already_built_response
  end

  def render_content(content, content_type)
    raise 'Already built response' if already_built_response?
    res.body = content
    res.content_type = content_type
    @already_built_response = true

    nil
  end

  def redirect_to(url)
    raise 'Already rendered response' if already_built_response?
    res.status = 302
    res.header['location'] = url
    @already_built_response = true

    nil
  end

  private
  attr_writer :req, :res

end
