provider "vault" {
#Uses VAULT_ADDR and VAULT_TOKEN environment variables
  address = data.terraform_remote_state.credentials.outputs.VAULT_ADDR
  token = data.terraform_remote_state.credentials.outputs.HCP_VAULT_ADMIN_TOKEN
}

data "terraform_remote_state" "credentials" {
  backend = "remote"

  config = {
    organization = "tfc-gcp-demo"
    workspaces = {
      name = "gcp-security-demo-hcp-vault"
    }
  }
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

resource "google_service_account" "this" {
  account_id = "my-awesome-account"
  display_name = "Service Account"
}

resource "vault_gcp_secret_static_account" "static_account" {
  backend        = vault_gcp_secret_backend.gcp.path
  static_account = "project_viewer"
  secret_type    = "access_token"
  token_scopes   = ["https://www.googleapis.com/auth/cloud-platform"]

  service_account_email = google_service_account.this.email
  
  # Optional
  binding {
    resource = "//cloudresourcemanager.googleapis.com/projects/${google_service_account.this.project}"

    roles = [
      "roles/owner",
    ]
  }
}
