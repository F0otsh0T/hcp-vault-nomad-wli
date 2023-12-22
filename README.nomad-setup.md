---
title: "HashiCorp Nomad <=> Vault Integration: Workload Identity - Built In Nomad Vault Setup"
description: "JWT-Based Workload Identities for Nomad - Integration with Hashicorp Vault - Built In Nomad Vault Setup"
---

# Nomad Vault Setup

## Help
```shell
$ nomad setup --help
Usage: nomad setup <subcommand> [options] [args]

  This command groups helper subcommands used for setting up external tools.

  Setup Consul for Nomad:

      $ nomad setup consul -y

  Please see the individual subcommand help for detailed usage information.

Subcommands:
    consul    Setup a Consul cluster for Nomad integration
    vault     Setup a Vault cluster for Nomad integration

$ nomad setup vault --help
Usage: nomad setup vault [options]

  This command sets up Vault for allowing Nomad workloads to authenticate
  themselves using Workload Identity.

  This command requires acl:write permissions for Vault and respects
  VAULT_TOKEN, VAULT_ADDR, and other Vault-related environment variables
  as documented in https://developer.hashicorp.com/vault/docs/commands#environment-variables.

  WARNING: This command is an experimental feature and may change its behavior
  in future versions of Nomad.

Setup Vault options:

  -jwks-url <url>
    URL of Nomad's JWKS endpoint contacted by Vault to verify JWT
    signatures. Defaults to http://localhost:4646/.well-known/jwks.json.

  -destroy
    Removes all configuration components this command created from the
    Vault cluster.

  -y
    Automatically answers "yes" to all the questions, making the setup
    non-interactive. Defaults to "false".
```

## Sample Setup
```shell
nomad setup vault -jwks-url http://host.docker.internal:4646/.well-known/jwks.json

This command will walk you through configuring all the components required for
Nomad workloads to authenticate themselves against Vault ACL using their
respective workload identities.

First we need to connect to Vault.

[?] Is "http://127.0.0.1:18200" the correct address of your Vault cluster? [Y/n] y

Since you're running Vault Enterprise, we will additionally create
a namespace "nomad-workloads" and create all configuration within that namespace.

[?] Create the namespace "nomad-workloads" in your Vault cluster? [Y/n] y
[✔] Created namespace "nomad-workloads".

We will now enable the JWT credential backend and create a JWT auth method that
Nomad workloads will use.

This is the method configuration:

{
    "default_role": "nomad-workloads",
    "jwks_url": "http://host.docker.internal:4646/.well-known/jwks.json",
    "jwt_supported_algs": [
        "EdDSA",
        "RS256"
    ]
}
[?] Create JWT auth method in your Vault cluster? [Y/n] y
[✔] Created JWT auth method "jwt-nomad".

We need to create a role that Nomad workloads will assume while authenticating,
and a policy associated with that role.
	

These are the rules for the policy "nomad-workloads" that we will create. It uses a templated
policy to allow Nomad tasks to access secrets in the path
"secrets/data/<job namespace>/<job name>":

path "secret/data/{{identity.entity.aliases.auth_jwt_d65f4db9.metadata.nomad_namespace}}/{{identity.entity.aliases.auth_jwt_d65f4db9.metadata.nomad_job_id}}/*" {
  capabilities = ["read"]
}

path "secret/data/{{identity.entity.aliases.auth_jwt_d65f4db9.metadata.nomad_namespace}}/{{identity.entity.aliases.auth_jwt_d65f4db9.metadata.nomad_job_id}}" {
  capabilities = ["read"]
}

path "secret/metadata/{{identity.entity.aliases.auth_jwt_d65f4db9.metadata.nomad_namespace}}/*" {
  capabilities = ["list"]
}

path "secret/metadata/*" {
  capabilities = ["list"]
}

[?] Create the above policy in your Vault cluster? [Y/n] y
[✔] Created policy "nomad-workloads".

We will now create an ACL role called "nomad-workloads" associated with the policy above.

{
    "bound_audiences": "vault.io",
    "claim_mappings": {
        "nomad_job_id": "nomad_job_id",
        "nomad_namespace": "nomad_namespace",
        "nomad_task": "nomad_task"
    },
    "role_type": "jwt",
    "token_period": "30m",
    "token_policies": [
        "nomad-workloads"
    ],
    "token_type": "service",
    "user_claim": "/nomad_job_id",
    "user_claim_json_pointer": true
}
[?] Create role in your Vault cluster? [Y/n] y
[✔] Created role "nomad-workloads".

Congratulations, your Vault cluster is now setup and ready to accept Nomad
workloads with Workload Identity!

You need to adjust your Nomad client configuration in the following way:

vault {
  enabled = true
  address = "<Vault address>"

  # Vault Enterprise only.
  # namespace = "<namespace>"

  jwt_auth_backend_path = "jwt-nomad/"
}

And your Nomad server configuration in the following way:

vault {
  enabled = true

  default_identity {
    aud = ["vault.io"]
    ttl = "1h"
  }
}
```