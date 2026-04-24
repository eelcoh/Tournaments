# Activities feed: unauth read + comment, authed blog post.

POST {{base_url}}/authentication/authentications
Content-Type: application/json
{
  "username": "{{test_user}}",
  "password": "{{test_pass}}"
}
HTTP 200
[Captures]
token: jsonpath "$.token"


GET {{base_url}}/activities
HTTP 200
[Asserts]
jsonpath "$.activities" isCollection


POST {{base_url}}/activities/comments
Content-Type: application/json
file,fixtures/comment.json;
HTTP 200
[Asserts]
jsonpath "$.activities" isCollection


POST {{base_url}}/activities/blogs
Authorization: Bearer {{token}}
Content-Type: application/json
file,fixtures/blog.json;
HTTP 200
[Asserts]
jsonpath "$.activities" isCollection


POST {{base_url}}/activities/blogs
Content-Type: application/json
file,fixtures/blog.json;
HTTP *
[Asserts]
status >= 400
status < 500
