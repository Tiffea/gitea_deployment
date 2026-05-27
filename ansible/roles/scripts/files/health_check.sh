#!/bin/bash
# read with /bin/bash

PATH=/usr/local/bin:/usr/bin:/bin
#from left to right (separated with :)
cd /home/ubuntu/gitea_deployment || exit 1
#open door or stop

if ! docker ps | grep -q gitea; then
  docker compose up -d
fi
# if not true then container up


if docker ps | grep -q gitea; then
  echo "working"
else
  echo "not working"
fi
#if not working say it