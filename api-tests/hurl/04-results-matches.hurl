# Admin: match results list, initial seed, per-match update.
# Mutating requests are gated behind RUN_MUTATING=1.

POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"


GET {{base_url}}/bets/results/matches/
HTTP 200
[Asserts]
jsonpath "$.results" isCollection


POST {{base_url}}/bets/results/matches/initial/
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
file,fixtures/match-results-initial.json;
HTTP 200
[Asserts]
jsonpath "$.results" isCollection


PUT {{base_url}}/bets/results/matches/m1
Authorization: Bearer {{token}}
Content-Type: application/json
[Options]
skip: {{skip_mutating}}
file,fixtures/match-result.json;
HTTP 200
[Asserts]
jsonpath "$.results" isCollection


PUT {{base_url}}/bets/results/matches/m1
Content-Type: application/json
file,fixtures/match-result.json;
HTTP *
[Asserts]
status >= 400
status < 500
