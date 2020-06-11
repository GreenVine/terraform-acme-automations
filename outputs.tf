output "acme_account_id" {
  description = "ACME account ID"
  value       = acme_registration.acme_account.id
}

output "acme_account_fingerprint" {
  description = "ACME account public key fingerprint (in MD5)"
  value       = replace(tls_private_key.account_key.public_key_fingerprint_md5, ":", "")
}
