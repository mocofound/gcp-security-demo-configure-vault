output "VAULT_ADDR" {
    value = vault_gcp_secret_roleset.service_account_email
}

output "roleset" {
    value = vault_gcp_secret_roleset.roleset.secret_type
}

