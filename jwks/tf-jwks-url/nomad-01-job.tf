# nomad-01-job.tf
# https://registry.terraform.io/providers/hashicorp/nomad/latest/docs
# https://registry.terraform.io/providers/hashicorp/nomad/latest/docs/resources/job
#

resource "nomad_job" "app" {
  jobspec = file("${path.module}/nomad-01-job.hcl")
}


















