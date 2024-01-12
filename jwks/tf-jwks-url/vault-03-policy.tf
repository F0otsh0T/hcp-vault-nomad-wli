# vault-02-policy.hcl
# https://developer.hashicorp.com/nomad/tutorials/integrate-vault/vault-acl#create-a-vault-acl-policy
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy

resource "vault_policy" "nomad-workloads" {
  name       = "nomad-workloads"
  depends_on = [vault_jwt_auth_backend.jwt-nomad]
  policy     = <<EOT
path "kv/data/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt-nomad.accessor}.metadata.nomad_namespace}}/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt-nomad.accessor}.metadata.nomad_job_id}}/*" {
  capabilities = ["read"]
}

path "kv/data/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt-nomad.accessor}.metadata.nomad_namespace}}/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt-nomad.accessor}.metadata.nomad_job_id}}" {
  capabilities = ["read"]
}

path "kv/metadata/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt-nomad.accessor}.metadata.nomad_namespace}}/*" {
  capabilities = ["list"]
}

path "kv/metadata/*" {
  capabilities = ["list"]
}
EOT
}