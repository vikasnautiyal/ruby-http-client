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
  def make_request(_http, _request)
    response = {}
    response['code'] = 200
    response['body'] = { 'message' => 'success' }
    response['headers'] = { 'headers' => 'test' }
    MockResponse.new(response)
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
    @client = MockRequest.new(host: @host,
                              request_headers: @headers,
                              version: @version)
  end

  def test_init
    assert_equal(@host, @client.host)
    assert_equal(@headers, @client.request_headers)
  end

  def test_update_headers
    request_headers = { 'X-Test' => 'test' }
    @client.update_headers(request_headers)
    assert_equal(@headers.merge(request_headers), @client.request_headers)
  end

  def test_build_request_headers
    request = {}
    request = @client.build_request_headers(request)
    assert_equal(@client.request_headers, request)
  end

  def test_add_version
    url = ''
    @client.add_version(url)
    assert_equal(url, "/#{@version}")
  end

  def test_build_query_params
    url = ''
    query_params = { 'limit' => 100, 'offset' => 0 }
    url = @client.build_query_params(url, query_params)
    assert_equal(url, '?limit=100&offset=0')
  end

  def test_build_url
    url1 = @client.my.path.to.the.endpoint
    params = { 'limit' => 100, 'offset' => 0 }
    url = URI.parse(@host + '/' + @version +
                    '/my/path/to/the/endpoint?limit=100&offset=0')
    assert_equal(url1.build_url(query_params: params), url)

    url1 = url1.one_more
    params = { 'limit' => 100, 'offset' => 0 }
    url = URI.parse(@host + '/' + @version +
                    '/my/path/to/the/endpoint/one_more?limit=100&offset=0')
    assert_equal(url1.build_url(query_params: params), url)

    url2 = @client.my.path._('to').the.endpoint
    params = { 'limit' => 100, 'offset' => 0 }
    url = URI.parse(@host + '/' + @version +
                    '/my/path/to/the/endpoint?limit=100&offset=0')
    assert_equal(url2.build_url(query_params: params), url)
  end

  def test_build_request
    name = 'get'
    args = nil
    response = @client.build_request(name, args)
    assert_equal(response.status_code, 200)
    assert_equal(response.response_body, 'message' => 'success')
    assert_equal(response.response_headers, 'headers' => 'test')
  end

  def add_ssl
    uri = URI.parse('https://localhost:4010')
    http = Net::HTTP.new(uri.host, uri.port)
    http = @client.add_ssl(http)
    assert_equal(http.use_ssl, true)
    assert_equal(http.verify_mode, OpenSSL::SSL::VERIFY_NONE)
  end

  def test__
    url1 = @client._('test')
    assert_equal(url1.url_path, ['test'])
  end

  def test_method_missing
    response = @client.get
    assert_equal(response.status_code, 200)
    assert_equal(response.response_body, 'message' => 'success')
    assert_equal(response.response_headers, 'headers' => 'test')
  end
end
