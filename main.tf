provider "vault" {
#Uses VAULT_ADDR and VAULT_TOKEN environment variables
}

resource "vault_generic_secret" "example" {
  path = "secret/foo"

  data_json = jsonencode(
    {
      "foo"   = "bar",
      "pizza" = "cheese"
    }
  )
}

resource "vault_gcp_secret_backend" "gcp" {
  credentials = var.gcp_creds
}
