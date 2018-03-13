#!/bin/bash

host="${1:-'http://localhost:3000'}"
users=()

echo -e "\n=> CREATING 10 NEW USERS \n"
for (( i = 0; i < 10; i++ )); do
  # create a new user
  id=$(curl -H "Content-Type: application/json" -X POST "${host}/user" -d '{"name": "John"}' | jq -r '.id')

  # update user state
  curl -X PUT "${host}/user/${id}/state" \
  -H "Content-Type: application/json" \
  -d '{ "gamesPlayed": '$(( RANDOM % 99 ))', "score": '${RANDOM}' }' \
  | jq .

  # add user to array
  users+=($id)
done

echo -e "\n=> ADDING FRIENDS TO NEW USERS \n"
for id in ${users[@]}; do
  # create friends array
  friends=$(for user in ${users[@]}; do echo -n "\"$user\","; done | sed '$ s/.$//')

  # update user friends
  curl -X PUT "${host}/user/${id}/friends" \
  -H "Content-Type: application/json" \
  -d "{ \"friends\": [ $friends ] }" \
  | jq .
done

echo -e "\n=> LISTING ALL USERS \n"
curl -X GET "${host}/user/" | jq .
