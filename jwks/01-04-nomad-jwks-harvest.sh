#!/bin/bash

set -euxo pipefail

sleep 2

#cd "$(dirname "$0")"

# Harvest the JWKS from the Nomad server

curl -s http://0.0.0.0:4646/.well-known/jwks.json | jq -r '.keys[0]' > jwk
pem-jwk jwk > pem.rsa
openssl rsa -RSAPublicKey_in -in pem.rsa -pubout -out pem.x509












