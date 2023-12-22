# variables.tf

/*
variable "" {
    type = string
    description = ""
    sensitive = false
    default = ""
}
*/

variable "nomad_server_addr" {
  type        = string
  description = "Nomad Server Address"
  sensitive   = false
  default     = "127.0.0.1"
}

variable "nomad_server_port" {
  type        = string
  description = "Nomad Server Port"
  sensitive   = false
  default     = "4646"
}

variable "nomad_jwks_url" {
  type        = string
  description = "Nomad JWKS URL"
  sensitive   = false
  default     = "http://0.0.0.0:4646/.well-known/jwks.json"
}

variable "vault_server_addr" {
  type        = string
  description = "Vault Server Address"
  sensitive   = false
  default     = "127.0.0.1"
}

variable "vault_server_port" {
  type        = string
  description = "Vault Server Port"
  sensitive   = false
  default     = "8200"
}

variable "vault_server_skip_tls_verify" {
  type        = string
  description = "Skip TLS Verification"
  sensitive   = false
  default     = "true"
}





