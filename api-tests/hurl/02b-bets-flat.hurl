# Bets (flat bracket wire format): login, create, fetch, update, 404.

POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"


POST {{base_url}}/bets/flat/
Content-Type: application/json
file,fixtures/bet-flat.json;
HTTP 200
[Captures]
bet_flat_uuid: jsonpath "$.bet.uuid"
[Asserts]
jsonpath "$.bet.uuid" exists
jsonpath "$.bet.uuid" isString
jsonpath "$.bet.answers.bracket.bracket.nodes" isCollection
jsonpath "$.bet.answers.bracket.bracket.nodes[0].slot" exists
jsonpath "$.bet.answers.bracket.bracket.nodes[0].kind" exists


GET {{base_url}}/bets/flat/{{bet_flat_uuid}}
HTTP 200
[Asserts]
jsonpath "$.bet.uuid" == "{{bet_flat_uuid}}"
jsonpath "$.bet.answers.bracket.bracket.nodes" isCollection


PUT {{base_url}}/bets/flat/{{bet_flat_uuid}}
Content-Type: application/json
file,fixtures/bet-flat-update.json;
HTTP 200
[Asserts]
jsonpath "$.bet.uuid" == "{{bet_flat_uuid}}"
jsonpath "$.bet.participant.name" == "Mock Updated Flat"


GET {{base_url}}/bets/flat/does-not-exist-{{bet_flat_uuid}}
HTTP *
[Asserts]
status >= 400
status < 500
