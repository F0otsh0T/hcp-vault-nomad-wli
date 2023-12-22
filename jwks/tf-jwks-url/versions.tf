# versions.tf

terraform {
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "2.1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }
  }
}










