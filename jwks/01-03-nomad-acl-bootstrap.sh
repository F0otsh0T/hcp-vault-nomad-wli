#!/bin/bash

set -euxo pipefail

sleep 2

#cd "$(dirname "$0")"

# Bootstrap Nomad ACLs

nomad acl bootstrap -json | jq > 01-03-nomad-acl-bootstrap.json

export NOMAD_TOKEN=$(jq -r .SecretID 01-03-nomad-acl-bootstrap.json)

tee 01-03-nomad-acl-bootstrap.env <<EOF
export NOMAD_TOKEN=$(jq -r .SecretID 01-03-nomad-acl-bootstrap.json)
EOF










