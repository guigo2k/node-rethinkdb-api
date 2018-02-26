#!/bin/bash

users=()
echo "Creating 10 new users"
for (( i = 0; i < 10; i++ )); do
  id=$(curl -X POST "http://localhost:3000/user" -H "Content-Type: application/json" -d '{"name": "John"}' | jq -r '.id')
  curl -X PUT "http://localhost:3000/user/${id}/state" \
  -H "Content-Type: application/json" \
  -d '{ "gamesPlayed": '$(( RANDOM % 99 ))', "score": '${RANDOM}' }' \
  | jq .
  users+=($id)
done

sleep 3

echo "Adding friends to new users"
for id in ${users[@]}; do
  local friends=$(for user in ${users[@]}; do echo -n "\"$user\","; done | sed '$ s/.$//')
  curl -X PUT "http://localhost:3000/user/${id}/friends" \
  -H "Content-Type: application/json" \
  -d "{ \"friends\": [ $friends ] }" \
  | jq .
done

curl -X GET "http://localhost:3000/user/${id}/friends" | jq .
curl -X GET "http://localhost:3000/user/" | jq .
