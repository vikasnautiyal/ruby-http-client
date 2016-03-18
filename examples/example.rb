require_relative '../lib/config'
require_relative '../lib/ruby_http_client'

Config.new
headers = JSON.parse('
  {
    "Authorization": "Bearer ' + ENV['SENDGRID_API_KEY'] + '",
    "Content-Type": "application/json"
  }
')
host = ENV['LOCAL_HOST']
client = SendGrid::Client.new(host: host, request_headers: headers)

# GET Collection
query_params = { 'limit' => 100, 'offset' => 0 }
response = client.version('v3').api_keys.get(query_params: query_params)
puts response.status_code
puts response.response_body
puts response.response_headers

# POST
request_body = JSON.parse('
    {
        "name": "My API Key Ruby Test",
        "scopes": [
            "mail.send",
            "alerts.create",
            "alerts.read"
        ]
    }
')
response = client.version('v3').api_keys.post(request_body: request_body)
puts response.status_code
puts response.response_body
puts response.response_headers
api_key_id = JSON.parse(response.response_body)['api_key_id']

# GET Single
response = client.version('v3').api_keys._(api_key_id).get
puts response.status_code
puts response.response_body
puts response.response_headers

# PATCH
request_body = JSON.parse('
    {
        "name": "A New Hope"
    }
')
response = client.api_keys._(api_key_id).patch(request_body: request_body)
puts response.status_code
puts response.response_body
puts response.response_headers

# PUT
request_body = JSON.parse('
    {
        "name": "A New Hope",
        "scopes": [
            "user.profile.read",
            "user.profile.update"
        ]
    }
')
response = client.api_keys._(api_key_id).put(request_body: request_body)
puts response.status_code
puts response.response_body
puts response.response_headers

# DELETE
response = client.api_keys._(api_key_id).delete
puts response.status_code
puts response.response_headers
