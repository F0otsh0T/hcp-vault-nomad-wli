vault {
  enabled = true
  address = "http://0.0.0.0:18200"

  # Vault Enterprise only.
  # namespace = "<namespace>"
  # namespace = "nomad-workloads"
  jwt_auth_backend_path = "jwt-nomad/"
}

