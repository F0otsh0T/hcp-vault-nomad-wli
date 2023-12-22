---
title: "HashiCorp Nomad <=> Vault Integration: Workload Identity - High Level"
description: "JWT-Based Workload Identities for Nomad - Integration with Hashicorp Vault"
---

# HashiCorp Nomad <=> Vault Integration: Workload Identity (HIGH LEVEL)

## Background
[![High Level Flow - Nomad Workload Identity](assets/nomad-wli.01.gif)](https://www.hashicorp.com/blog/nomad-1-7-improves-vault-and-consul-integrations-adds-numa-support)

This example set is based on the following:
- https://gist.github.com/sofixa/17b9a5060851dc1dd95df3426978427e
- https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-acl
- https://developer.hashicorp.com/nomad/tutorials/single-sign-on/sso-oidc-vault

## Prerequisites

- Nomad *`1.7x+`*
- Vault *`1.12+`*
  - `VAULT_ADDR`
  - `VAULT_TOKEN`
- Docker
- [pem-jwk](https://www.npmjs.com/package/pem-jwk) (`npm install -g pem-jwk`), manually utilize [jwt.io](https://jwt.io/), or similar tools
- curl
- jq
- npm
- make

## High Level Steps

- Set Up Vault
  - Create a Policy for Nomad in Vault
  - Enable the JWT Auth Method
  - Configure Vault to use Nomad’s Public keys - either passing in the keys, a JWKS URL, or an OIDC Config URL
  - Create a Vault Role for Nomad
- Set up Nomad
  - Pass a Vault URL into Nomad Server config in a new configuration block (or v2 of the existing vault block). (Note: no token needed)
- Deploy Job
  - Job is configured to use new Vault integration
  - Nomad, recognizing that the new integration is being used, automatically requests a token for this job using the JWT auth method.

## Detailed Steps

Reference **[README >>HERE<<](./README.detailed.md)**


## Reference

#### Vault Integration
- https://developer.hashicorp.com/nomad/docs/integrations/vault-integration
- https://developer.hashicorp.com/nomad/tutorials/integrate-vault
- https://developer.hashicorp.com/nomad/docs/concepts/workload-identity
- https://developer.hashicorp.com/vault/api-docs/auth/jwt#jwks_url
- https://www.hashicorp.com/blog/nomad-1-7-improves-vault-and-consul-integrations-adds-numa-support
- https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-acl
- https://developer.hashicorp.com/nomad/docs/job-specification/vault
- https://developer.hashicorp.com/nomad/api-docs/operator/keyring#oidc-discovery



#### Nomad OIDC Endpoint
- https://developer.hashicorp.com/nomad/docs/configuration/server#oidc_issuer
- Sample Config Server Block:
  ```hcl
  server {
  enabled          = true
  bootstrap_expect = 3
  server_join {
    retry_join     = [ "1.1.1.1", "2.2.2.2" ]
    retry_max      = 3
    retry_interval = "15s"
    }
  }
  ```

#### Nomad Server Start with Config
- https://developer.hashicorp.com/nomad/docs/configuration#load-order-and-merging
- [Example](https://medium.com/hashicorp-engineering/hashicorp-nomad-from-zero-to-wow-1615345aa539):
  ```shell
  $ nomad agent -dev -config /path/to/my/config.hcl

  $ nomad agent -dev -config=<( echo 'client {options = {"driver.blacklist" = "java"}}' )
  ```

