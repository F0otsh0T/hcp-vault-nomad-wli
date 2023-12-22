# vault-01-auth-jwt.hcl
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend
# 

resource "vault_jwt_auth_backend" "jwt-nomad" {
  description        = "Vault JWT Auth for Nomad - JWKS URL"
  path               = "jwt-nomad"
  jwt_supported_algs = ["RS256", "EdDSA"]
  default_role       = "nomad-workloads"
#  jwks_url           = "http://host.docker.internal:4646/.well-known/jwks.json"
  jwks_url           = "${var.nomad_jwks_url}"
}


