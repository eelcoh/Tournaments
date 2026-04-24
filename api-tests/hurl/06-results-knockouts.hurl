POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"


GET {{base_url}}/bets/results/knockouts/
HTTP 200
[Asserts]
jsonpath "$.teams" exists


POST {{base_url}}/bets/results/knockouts/initial/
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
{}
HTTP 200
[Asserts]
jsonpath "$.teams" exists


POST {{base_url}}/bets/results/knockouts/
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
file,fixtures/knockouts-results.json;
HTTP 200
[Asserts]
jsonpath "$.teams" exists


POST {{base_url}}/bets/results/knockouts/
Content-Type: application/json
file,fixtures/knockouts-results.json;
HTTP *
[Asserts]
status >= 400
status < 500
