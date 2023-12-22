---
title: "HashiCorp Nomad <=> Vault Integration: Workload Identity - Detailed"
description: "JWT-Based Workload Identities for Nomad - Integration with Hashicorp Vault"
---

# HashiCorp Nomad <=> Vault Integration: Workload Identity (DETAILED)

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

## Steps: Nomad

#### OIDC / JWKS Discovery
When starting the Nomad agents for the Nomad cluster, you'll need to specify the [Nomad OIDC Configuration Endpoints](https://developer.hashicorp.com/nomad/docs/configuration/server#oidc_issuer) (`../.well-known/openid-configuration` and `../.well-known/jwks.json`) so that it is discoverable by third party IDP platforms.

The `oidc_issuer` is the URL root from which the `../.well-known/*` endpoints can be consumed.

***NOTE***: Perspective of the Nomad OIDC Endpoint consumer needs to be accounted for - a few examples:
- Docker: If your IDP/Vault is running in Docker, `host.docker.internal` should be utilized from the container.
- Load-Balancer/GTM/DNS: that front-ended IP and/or FQDN needs to be accounted for in the `oidc_issuer` configuration)

Example Configurations and Outputs:
- E.g. Nomad OIDC Server Configuration ([jwks-public-key-01-00-nomad-server-oidc.hcl](jwks-public-key/01-00-nomad-server-oidc.hcl)) - in this case, Nomad is running locally and is exposed on Port `:4646`.
  ```hcl
  server {
  #    oidc_issuer = "http://{{$FQDN}}:{{$PORT}}"
  #    oidc_issuer = "https://{{$FQDN}}:{{$PORT}}"
  #    oidc_issuer = "http://0.0.0.0:4646"
      oidc_issuer = "http://host.docker.internal:4646"
  }
  ```
- E.g. Start Nomad
  ```shell
  nomad agent -dev \
    -config path/to/config/01-00-nomad-server-oidc.hcl \
    -bind 0.0.0.0 \
    -network-interface='{{ GetDefaultInterfaces | attr "name" }}' &
  ```
- E.g. `../.well-known/openid-configuration`
  ```shell
  curl -s http://host.docker.internal:4646/.well-known/openid-configuration | jq
  {
    "id_token_signing_alg_values_supported": [
      "RS256",
      "EdDSA"
    ],
    "issuer": "http://host.docker.internal:4646",
    "jwks_uri": "http://host.docker.internal:4646/.well-known/jwks.json",
    "response_types_supported": [
      "code"
    ],
    "subject_types_supported": [
      "public"
    ]
  }
  ```
- E.g. `../.well-known/jwks.json`
  ```shell
  curl -s http://host.docker.internal:4646/.well-known/jwks.json | jq
  {
    "keys": [
      {
        "use": "sig",
        "kty": "RSA",
        "kid": "110a70ac-76a5-16a7-4ae7-bb0865ecd1a5",
        "alg": "RS256",
        "n": "qxyG-7uLQiCQ1dZSGPd0W-36kA4VtpDHfEbzHyfXJs7Aft2GKVuztLSK4Rye9-ECL1UOjSJ_qNphPdu3vewHB9C1u-B2u0yTpQuXBiDon2pEDvXU4jy0icCrGYEbmzaBJiZoMWhFpDi_bUFl6s7v6HikjIw0t0qiEZBIMYiWGMJC2xOsgtTOsxn4qCK2YYiqHBHMpWGRLceWlpWSt_vxUqmcjJ0xsOaxvz8vD9DvCLMtV5kO6YS4v9wgwZeRmOB2H21ADZMn2ssyRMQUGwF9Qaj0rpfm7cA9_nEaPniaZc2WT9FS-Nch7qOVEhznaT8KANhiei8q4e8wvl4_TRsSvw",
        "e": "AQAB"
      }
    ]
  }
  ```

## Set Up Vault

#### Create a Policy for Nomad in Vault
[Write a policy for Nomad Workload Identity](https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-acl#create-a-vault-acl-policy). `AUTH_METHOD_ACCESSOR` is a placeholder for the actual Vault Auth Accessor for the JWT Auth method 

- Terraform:
`./jwks-public-key/tf-jwks-url/vault-02-policy.tf` or:
- Shell:
  ```shell
  tee nomad-server-policy.hcl <<EOF

  path "kv/data/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_namespace}}/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_job_id}}/*" {
  capabilities = ["read"]
  }
  
  path "kv/data/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_namespace}}/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_job_id}}" {
  capabilities = ["read"]
  }
  
  path "kv/metadata/{{identity.entity.aliases.AUTH_METHOD_ACCESSOR.metadata.nomad_namespace}}/*" {
    capabilities = ["list"]
  }
  
  path "kv/metadata/*" {
    capabilities = ["list"]
  }
  EOF
  ```

  ```shell
  vault policy write nomad-server nomad-server-policy.hcl
  ```

#### Enable JWT Auth Method
- Terraform
`./02-vault-jwt-auth.tf` or:
- Shell
  ```shell
  vault auth enable jwt
  ```

  ```shell
  vault write auth/jwt/config \
    oidc_discovery_url="http://0.0.0.0:4646/.well-known/openid-configuration" \
    oidc_client_id="" \
    oidc_client_secret="" \
  ```

  ```shell
  vault write auth/jwt/role/demo \
      allowed_redirect_uris="http://localhost:8250/oidc/callback" \
      bound_subject="r3qX9DljwFIWhsiqwFiu38209F10atW6@clients" \
      bound_audiences="https://vault.plugin.auth.jwt.test" \
      user_claim="https://vault/user" \
      groups_claim="https://vault/groups" \
      policies=webapps \
      ttl=1h
  ```