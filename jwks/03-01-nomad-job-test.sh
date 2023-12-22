#!/bin/bash

set -euxo pipefail

sleep 2

#cd "$(dirname "$0")"

# Test Nomad Job
source 01-03-nomad-acl-bootstrap.env

#echo $NOMAD_TOKEN

nomad alloc exec "$(nomad job allocs -t '{{with (index . 0)}}{{.ID}}{{end}}' 'mongo')" mongosh --username 'root' --password 'secret-password' --eval 'db.runCommand({connectionStatus : 1})' --quiet > 03-01-nomad-job-test.authenticate.out

nomad job inspect -t '{{sprig_toPrettyJson (index (index .TaskGroups 0).Tasks 0)}}' 'mongo' > 03-01-nomad-job-test.inspect.out







