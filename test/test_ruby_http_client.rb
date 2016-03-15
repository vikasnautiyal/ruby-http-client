require_relative '../lib/config'
require_relative '../lib/ruby_http_client'
require 'minitest/autorun'

class MockResponse
  attr_reader :status_code, :response_body, :response_headers
  
  def initialize(response)
    @status_code = response['code']
    @response_body = response['body']
    @response_headers = response['headers']
  end
end

class MockRequest < SendGrid::Client
  def make_request(http, request)
     response = {}
     response['code'] = 200
     response['body'] = {"message": "success"}
     response['headers'] = {"headers" => "test"}
     return MockResponse.new(response)
  end
end

class TestClient < Minitest::Test
  def setup
    @headers = JSON.parse('
            { 
                "Authorization": "Bearer XXXXXXX",
                "Content-Type": "application/json" 
            }
        ')
    @host = 'http://localhost:4010'
    @version = 'v3'
    @client = MockRequest.new(host: @host, request_headers: @headers, version: @version)
  end
  
  def test_init
   assert_equal(@host, @client.host)
   assert_equal(@headers, @client.request_headers)
  end
  
  def test_update_headers
    request_headers = {"X-Test" => "test"}
    @client.update_headers(request_headers)
    assert_equal(@headers.merge(request_headers), @client.request_headers)
  end
  
  def test_url_builder
    url1 = @client.my.path.to.the.endpoint
    params = {"limit" => 100, "offset" => 0}
    assert_equal(url1.build_url(query_params: params), @host + "/" + @version + "/my/path/to/the/endpoint?limit=100&offset=0")
    
    url1 = url1.one_more
    params = {"limit" => 100, "offset" => 0}
    assert_equal(url1.build_url(query_params: params), @host + "/" + @version + "/my/path/to/the/endpoint/one_more?limit=100&offset=0")
    
    url2 = @client.my.path._("to").the.endpoint
    params = {"limit" => 100, "offset" => 0}
    assert_equal(url2.build_url(query_params: params), @host + "/" + @version + "/my/path/to/the/endpoint?limit=100&offset=0")
  end

  def test__
    url1 = @client._("test")
    assert_equal(url1.url_path, ["test"])
  end
  
  def test_method_missing
    response = @client.get()
    assert_equal(response.status_code, 200)
    assert_equal(response.response_body, {"message": "success"})
    assert_equal(response.response_headers, {"headers" => "test"})
  end
end