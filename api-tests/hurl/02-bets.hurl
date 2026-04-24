# Bets CRUD: login, create, fetch, update, 404.

POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"


POST {{base_url}}/bets/
Content-Type: application/json
file,fixtures/bet.json;
HTTP 200
[Captures]
bet_uuid: jsonpath "$.bet.uuid"
[Asserts]
jsonpath "$.bet.uuid" exists
jsonpath "$.bet.uuid" isString
jsonpath "$.bet.participant.name" exists


GET {{base_url}}/bets/{{bet_uuid}}
HTTP 200
[Asserts]
jsonpath "$.bet.uuid" == "{{bet_uuid}}"
jsonpath "$.bet.active" isBoolean


PUT {{base_url}}/bets/{{bet_uuid}}
Content-Type: application/json
file,fixtures/bet-update.json;
HTTP 200
[Asserts]
jsonpath "$.bet.uuid" == "{{bet_uuid}}"
jsonpath "$.bet.participant.name" == "Mock Updated"


GET {{base_url}}/bets/does-not-exist-{{bet_uuid}}
HTTP *
[Asserts]
status >= 400
status < 500
