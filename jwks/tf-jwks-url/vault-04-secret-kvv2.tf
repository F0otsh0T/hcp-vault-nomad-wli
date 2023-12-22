# vault-04-secret-kvv2.hcl
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role
# 

resource "vault_mount" "kvv2" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "nomad-workloads" {
  mount               = vault_mount.kvv2.path
  name                = "default/mongo/config"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      foo           = "bar",
      hello         = "world",
      root_password = "secret-password",
      test          = "123",
      zip           = "zap"
    }
  )
}




