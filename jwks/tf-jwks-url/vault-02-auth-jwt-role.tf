# vault-03-auth-jwt-role.hcl
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role
# 

resource "vault_jwt_auth_backend_role" "nomad-workloads" {
  depends_on = [
    vault_jwt_auth_backend.jwt-nomad,
    vault_policy.nomad-workloads
  ]
  backend = vault_jwt_auth_backend.jwt-nomad.path
  claim_mappings = {
    "nomad_job_id" : "nomad_job_id",
    "nomad_namespace" : "nomad_namespace",
    "nomad_task" : "nomad_task"
  }
  role_name               = "nomad-workloads"
  token_policies          = ["default", "nomad-workloads"]
  token_type              = "service"
  token_period            = 1800
  token_explicit_max_ttl  = 0
  bound_audiences         = ["vault.io"]
  user_claim              = "/nomad_job_id"
  user_claim_json_pointer = true
  role_type               = "jwt"
}






