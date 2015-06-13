class IndifferentHash < Hash
  def [](key)
    super(key.to_s)
  end

  def []=(key, val)
    super(key.to_s, val)
  end
end

class Flash
  attr_reader :flash_now

  def initialize(req)
    @flash_now = IndifferentHash.new
    @data = IndifferentHash.new
    cookie = get_cookie(req)
    parse_cookie(cookie) unless cookie.nil?
  end

  def now
    @flash_now
  end

  def [](key)
    @flash_now[key] || @data[key]
  end

  def []=(key, val)
    now[key] = val
    @data[key] = val
  end

  def store_flash(res)
    cookie = WEBrick::Cookie.new('_ruby_on_rails_lite_flash_', @data.to_json)
    cookie.path = '/'
    res.cookies << cookie
  end

  private

  def get_cookie(req)
    req.cookies.find { |c| c.name == '_ruby_on_rails_lite_flash_' }
  end

  def parse_cookie(cookie)
    JSON.parse(cookie.value).each do |k, v|
      @flash_now[k] = v
    end
  end
end
