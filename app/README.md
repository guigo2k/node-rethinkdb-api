### HOST
```
host="http://localhost:3000"
```

#### POST /user
```
curl --insecure -X POST "${host}/user" \
-H "Content-Type: application/json" \
-d '{"name": "John"}' | jq .
```

#### PUT /user/:id/state
```
curl --insecure -X PUT "${host}/user/${id}/state" \
-H "Content-Type: application/json" \
-d '{ "gamesPlayed": 54, "score": 364 }' | jq .
```

#### PUT /user/:id/friends
```
curl --insecure -X PUT "${host}/user/${id}/friends" \
-H "Content-Type: application/json" \
-d '{ "friends": ["b51c6193-5a6f-42ff-8cf7-f21f4d492f5c", "e7997cd1-c863-4bf7-bb05-ed0a6f0091a4", "8927064e-9dd3-4855-839d-f0c8d524fafe"] }' | jq .
```

#### GET /user/:id
```
curl --insecure -X GET "${host}/user/${id}" | jq .
```

#### GET /user/:id/state
```
curl --insecure -X GET "${host}/user/${id}/state" | jq .
```

#### GET /user/:id/friends
```
curl --insecure -X GET "${host}/user/${id}/friends" | jq .
```

#### GET /user
```
curl --insecure -X GET "${host}/user" | jq .
```
