#!/bin/bash

set -euxo pipefail

sleep 2

#cd "$(dirname "$0")"

# Test Nomad Job
source 01-03-nomad-acl-bootstrap.env

#echo $NOMAD_TOKEN
echo "MongoDB Nomad Job Query"
nomad alloc exec "$(nomad job allocs -t '{{with (index . 0)}}{{.ID}}{{end}}' 'mongo')" mongosh --username 'root' --password 'secret-password' --eval 'db.runCommand({connectionStatus : 1})' --quiet > 03-01-nomad-job-test.query.out
cat 03-01-nomad-job-test.query.out

echo "MongoDB Nomad Job Inspect"
nomad job inspect -t '{{sprig_toPrettyJson (index (index .TaskGroups 0).Tasks 0)}}' 'mongo' > 03-01-nomad-job-test.inspect.out
cat 03-01-nomad-job-test.inspect.out

echo "MongoDB Nomad Job - Check Secrets"
docker exec -it $(docker ps | grep -i mongo | awk '{print $1}') cat /secrets/env > 03-01-nomad-job-test.secrets.out
cat 03-01-nomad-job-test.secrets.out






