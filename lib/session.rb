require 'json'
require 'webrick'

class Session
  def initialize(req)
    cookie = get_cookie(req)
    if cookie
      parse_cookie(cookie)
    else
      @data = {}
    end
  end

  def parse_cookie(cookie)
    @data = JSON.parse(cookie.value)
  end

  def get_cookie(req)
    req.cookies.find { |c| c.name == '_ruby_on_rails_lite_' }
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_ruby_on_rails_lite_', @data.to_json)
  end
end
