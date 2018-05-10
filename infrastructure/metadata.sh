#!/usr/bin/env bash


terraform output -json  | curl -H 'Content-Type: application/json' -d @- docker.for.mac.localhost:3000/app_infra
