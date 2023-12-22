# providers.tf

# Nomad
provider "nomad" {
  # Configuration options
  address = "http://${var.nomad_server_addr}:${var.nomad_server_port}"
}

# Vault
provider "vault" {
  # Configuration options
  address         = "http://${var.vault_server_addr}:${var.vault_server_port}"
  skip_tls_verify = var.vault_server_skip_tls_verify
}






