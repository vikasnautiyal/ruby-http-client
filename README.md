[![Travis Badge](https://travis-ci.org/sendgrid/python-http-client.svg?branch=master)](https://travis-ci.org/sendgrid/ruby-http-client)

**Quickly and easily access any REST or REST-like API.**

Here is a quick example:

`GET /your/api/{param}/call`

```ruby
require ruby_http_client
global_headers = {'Authorization' => 'Basic XXXXXXX' }
client = SendGrid::Client(host: 'base_url', request_headers: global_headers)
client.your.api._(param).call.get
puts response.status_code
puts response.response_body
puts response.response_headers
```

`POST /your/api/{param}/call` with headers, query parameters and a request body with versioning.

```ruby
import ruby_http_client
global_headers = {'Authorization' => 'Basic XXXXXXX' }
client = SendGrid::Client(host: 'base_url', request_headers: global_headers)
query_params = { 'hello' => 0, 'world' => 1 }
request_headers = { 'X-Test' => 'test' }
data = { 'some' => 1, 'awesome' => 2, 'data' => 3}
response = client.your.api._(param).call.post(request_body: data,
                                              query_params: query_params,
                                              request_headers: request_headers)
puts response.status_code
puts response.response_body
puts response.response_headers
```

# Installation

`gem install ruby_http_client`

## Usage ##

Following is an example using SendGrid. You can get your free account [here](https://sendgrid.com/free?source=python-http-client).

First, update your .env with your [SENDGRID_API_KEY](https://app.sendgrid.com/settings/api_keys) and HOST. For this example HOST=https://api.sendgrid.com.

Following is an abridged example, here is the [full working code](https://github.com/sendgrid/ruby-http-client/tree/master/examples).

```ruby
require ruby_http_client

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
api_key_id = JSON.parse(response.response_body)['api_key_id']

# GET Single
response = client.version('v3').api_keys._(api_key_id).get

# PATCH
request_body = JSON.parse('
    {
        "name": "A New Hope"
    }
')
response = client.api_keys._(api_key_id).patch(request_body: request_body)

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

# DELETE
response = client.api_keys._(api_key_id).delete
```

# Announcements

[2016.03.17] - We hit version 1!

# Roadmap

[Milestones](https://github.com/sendgrid/ruby-http-client/milestones)

# How to Contribute

We encourage contribution to our libraries, please see our [CONTRIBUTING](https://github.com/sendgrid/ruby-http-client/blob/master/CONTRIBUTING.md) guide for details.

* [Feature Request](https://github.com/sendgrid/ruby-http-client/blob/master/CONTRIBUTING.md#feature_request)
* [Bug Reports](https://github.com/sendgrid/ruby-http-client/blob/master/CONTRIBUTING.md#submit_a_bug_report)
* [Improvements to the Codebase](https://github.com/sendgrid/ruby-http-client/blob/master/CONTRIBUTING.md#improvements_to_the_codebase)

# Thanks

We were inspired by the work done on [birdy](https://github.com/inueni/birdy) and [universalclient](https://github.com/dgreisen/universalclient).

# About

![SendGrid Logo]
(https://assets3.sendgrid.com/mkt/assets/logos_brands/small/sglogo_2015_blue-9c87423c2ff2ff393ebce1ab3bd018a4.png)

ruby-http-client is guided and supported by the SendGrid [Developer Experience Team](mailto:dx@sendgrid.com).

ruby-http-client is maintained and funded by SendGrid, Inc. The names and logos for ruby-http-client are trademarks of SendGrid, Inc.
