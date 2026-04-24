# Login + capture token for downstream tests.
#
# Expects variables: base_url, test_user, test_pass

POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"
[Asserts]
jsonpath "$.token" exists
jsonpath "$.token" isString


# Missing credentials should not succeed.

POST {{base_url}}/authentication/authentications
Content-Type: application/json
{}
HTTP *
[Asserts]
status >= 400
status < 500
