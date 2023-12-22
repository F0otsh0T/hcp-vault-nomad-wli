#!/bin/bash

set -euxo pipefail

sleep 2

#cd "$(dirname "$0")"

# Start Nomad in Dev Mode
nomad agent -dev \
  -config ~/git/hcp/learn/hcp-vault-nomad-wli/jwks-public-key/01-00-nomad-server-oidc.hcl \
  -config ~/git/hcp/learn/hcp-vault-nomad-wli/jwks-public-key/01-00-nomad-server-vault.hcl \
  -bind 0.0.0.0 \
  -network-interface='{{ GetDefaultInterfaces | attr "name" }}' &

# sleep 2 && \
#   PID=$!

# wait $PID






