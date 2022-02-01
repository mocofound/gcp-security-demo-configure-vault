provider "vault" {
#Uses VAULT_ADDR and VAULT_TOKEN environment variables
  address=var.address
  token=var.token
}

resource "vault_gcp_secret_backend" "gcp" {
  credentials = var.gcp_creds
}

locals {
  project = "gcp-vault-demo-2022"
}


resource "vault_gcp_secret_roleset" "roleset" {
  backend      = vault_gcp_secret_backend.gcp.path
  roleset      = "project_owner"
  secret_type  = "access_token"
  project      = local.project
  token_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${local.project}"

    roles = [
      "roles/owner",
    ]
  }
}
