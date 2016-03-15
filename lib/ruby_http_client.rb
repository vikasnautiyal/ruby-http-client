require 'json'
require 'net/http'
require 'net/https'

module SendGrid
class Response
  def initialize(response)
    @status_code = response.code
    @response_body = response.body
    @response_headers = response.to_hash.inspect
  end
  
  def status_code
    @status_code
  end
  
  def response_body
    @response_body
  end
  
  def response_headers
    @response_headers
  end
end

class Client
  attr_reader :host, :request_headers, :url_path
  def initialize(host:, request_headers: nil, version: nil, url_path: nil)
    @host = host
    @request_headers = request_headers ? request_headers : {} 
    @version = version
    @url_path = url_path ? url_path : []
    @methods = ["delete", "get", "patch", "post", "put"]
  end
  
  def update_headers(request_headers)
    @request_headers = @request_headers.merge(request_headers)
  end
  
  def build_url(query_params: nil)
    url = ''
    if @version
      url.concat("/#{@version}")
    end
    @url_path.each do |x|
      url.concat("/#{x}")
    end
    if query_params
      url.concat("?")
      count = 0
      query_params.each do |key, value|
        if count > 0
          url.concat("&")
        end
        url.concat("#{key}=#{value}")
        count = count +1
      end
    end
    return "#{@host}#{url}"
  end
  
  def _(name = nil)
    url_path = name ? @url_path.push(name) : @url_path
    @url_path = []
    return Client.new(host: @host, request_headers: @request_headers, version: @version, url_path: url_path)
  end
  
  def make_request(http, request)
    response = http.request(request)
    return Response.new(response)
  end
  
  def method_missing(name, *args, &block)
    
    if name.to_s == "version"
      @version = args[0]
      return self._()
    end
    
    if @methods.include?(name.to_s)
      query_params = nil
      request_body = nil
      args.each do |value|
        value.each do |key, value|
           case key.to_s
           when "query_params"
             query_params = value
           when "request_headers"
             self.update_headers(value)
           when "request_body"
             request_body = value
           else
           end
        end
      end
      uri = URI.parse(self.build_url(query_params: query_params))
      http = Net::HTTP.new(uri.host, uri.port)
      protocol = host.split(":")[0]
      if protocol == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
      end
      net_http = Kernel.const_get('Net::HTTP::' + name.to_s.capitalize)
      request = net_http.new(uri.request_uri)
      @request_headers.each do |key, value|
        request[key] = value
      end
      if request_body
        request.body = request_body.to_json
      end
      return self.make_request(http, request)
    end
    
    return self._(name)
  end
end
end