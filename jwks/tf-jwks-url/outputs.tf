# outputs.tf

output "auth-jwt" {
  description = "Vault JWT Auth for Nomad"
  value       = vault_jwt_auth_backend.jwt-nomad
  sensitive   = true
}

output "auth-jwt-accessor" {
  description = "Vault JWT Auth Accessor for Nomad"
  value       = vault_jwt_auth_backend.jwt-nomad.accessor
}

output "auth-jwt-role" {
  description = "Vault JWT Auth Role for Nomad"
  value       = vault_jwt_auth_backend_role.nomad-workloads
}

output "policy-nomad-workloads" {
  description = "Vault Policy for Nomad Workloads"
  value       = vault_policy.nomad-workloads
}

output "secret-kv" {
  value = vault_mount.kvv2
}
