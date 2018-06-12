#!/usr/bin/env bash


terraform output -json  | curl -H 'Content-Type: application/json' -d @- host.docker.internal:3000/app_infra
