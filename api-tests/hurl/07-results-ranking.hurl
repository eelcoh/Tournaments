# Creates its own bet so ranking detail lookup hits a real uuid.

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


GET {{base_url}}/bets/ranking/
HTTP 200
[Asserts]
jsonpath "$.summary" isCollection
jsonpath "$.time" exists


GET {{base_url}}/bets/ranking/{{bet_uuid}}
HTTP 200
[Asserts]
jsonpath "$.uuid" == "{{bet_uuid}}"
jsonpath "$.bet" exists


POST {{base_url}}/bets/ranking/initial/
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
HTTP 200
[Asserts]
jsonpath "$.summary" isCollection


POST {{base_url}}/bets/ranking/initial/
Content-Type: application/json
HTTP *
[Asserts]
status >= 400
status < 500


GET {{base_url}}/bets/
HTTP 200
[Asserts]
jsonpath "$" isCollection


POST {{base_url}}/bets/deactivate/{{bet_uuid}}
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
HTTP 200
[Asserts]
jsonpath "$.bet.active" == false


POST {{base_url}}/bets/activate/{{bet_uuid}}
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
HTTP 200
[Asserts]
jsonpath "$.bet.active" == true
