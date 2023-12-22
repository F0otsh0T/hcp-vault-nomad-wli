#!/bin/bash

set -euxo pipefail

#sleep 3

#cd "$(dirname "$0")"

# Vault Auth Method Disable: JWT

vault auth disable jwt-nomad
