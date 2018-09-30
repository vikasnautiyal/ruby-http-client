# Usage

Usage examples for SendGrid ruby-http-client

## Initialization

```
require_relative '../lib/ruby_http_client'

# This uses the SendGrid API as an example
headers = JSON.parse('
  {
    "Authorization": "Bearer ' + ENV['SENDGRID_API_KEY'] + '"
  }
')
host = 'https://api.sendgrid.com'
client = SendGrid::Client.new(host: host, request_headers: headers)
```

## Table of Contents

- [GET](#get)
- [DELETE](#delete)
- [POST](#post)
- [PUT](#put)
- [PATCH](#patch)

<a name="get"></a>
## GET

#### GET Collection

```
query_params = { 'limit' => 100, 'offset' => 0 }
response = client.version('v3').api_keys.get(query_params: query_params)
puts response.status_code
puts response.body
puts response.headers
```

#### GET Single

```
response = client.version('v3').api_keys._(api_key_id).get
puts response.status_code
puts response.body
puts response.headers
```

<a name="delete"></a>
## DELETE

```
response = client.api_keys._(api_key_id).delete
puts response.status_code
puts response.headers
```

<a name="post"></a>
## POST

```
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
puts response.body
puts response.headers
api_key_id = JSON.parse(response.body)['api_key_id']
```

<a name="put"></a>
## PUT

```
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
puts response.body
puts response.headers
```

<a name="patch"></a>
## PATCH

```
request_body = JSON.parse('
    {
        "name": "A New Hope"
    }
')
response = client.api_keys._(api_key_id).patch(request_body: request_body)
puts response.status_code
puts response.body
puts response.headers
```