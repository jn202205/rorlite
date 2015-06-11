require 'uri'

class Params
  def initialize(req, route_params = {})
    @request, @route_params = req, route_params
    @params = {}
    parse_www_encoded_form(req.query_string)
    parse_www_encoded_form(req.body)
    @params = @params.merge(@route_params)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  def parse_www_encoded_form(www_encoded_form)
    return {} if www_encoded_form.nil?
    kv_pairs = URI.decode_www_form(www_encoded_form)
    kv_pairs.each do |pair|
      key, val = pair
      keys = parse_key(key)
      @params = @params.deep_merge(nest_keys(keys, val))
    end

    @params
  end

  def nest_keys(keys, val)
    keys.reverse.inject(val) { |v, k| { k => v } }
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end

end
