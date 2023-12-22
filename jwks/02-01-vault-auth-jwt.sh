#!/bin/bash

set -euxo pipefail

#sleep 3

#cd "$(dirname "$0")"

# Vault Auth Method: JWT

vault auth enable -path 'jwt-nomad' 'jwt'

# Write Nomad JWKS Public Key to Vault Auth

CERT="$(cat <<EOF
$(cat pem.x509)
EOF
)"

echo $CERT
echo "$CERT"

vault write auth/jwt-nomad/config \
    jwt_validation_pubkeys="$CERT"

# Write Nomad JWKS URL to Vault Auth
JWKS="$(cat <<EOF
{
  "jwks_url": "http://0.0.0.0:4646/.well-known/jwks.json",
  "jwt_supported_algs": ["RS256", "EdDSA"],
  "default_role": "nomad-workloads"
}
EOF
)"
echo $JWKS | jq

#vault write auth/jwt-nomad/config '@01-01-vault-auth-jwt.json'
#vault write auth/jwt-nomad/config "$JWKS"

vault read auth/jwt-nomad/config




