output "service_account_email" {
    value = vault_gcp_secret_roleset.roleset.service_account_email
}

output "secret_type" {
    value = vault_gcp_secret_roleset.roleset.secret_type
}
