POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"


GET {{base_url}}/bets/results/topscorer/
HTTP 200
[Asserts]
jsonpath "$.topscorers" isCollection


POST {{base_url}}/bets/results/topscorer/initial/
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
{}
HTTP 200
[Asserts]
jsonpath "$.topscorers" isCollection


POST {{base_url}}/bets/results/topscorer/
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
file,fixtures/topscorer-results.json;
HTTP 200
[Asserts]
jsonpath "$.topscorers" isCollection


POST {{base_url}}/bets/results/topscorer/
Content-Type: application/json
file,fixtures/topscorer-results.json;
HTTP *
[Asserts]
status >= 400
status < 500
