#!bin/bash
if ! docker ps | grep gitea; then
  docker compose up -d
fi


if docker ps | grep gitea; then
  echo "all is fine"; else
  echo "smth is wrong"
fi