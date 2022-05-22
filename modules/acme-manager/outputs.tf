locals {
  cert_sans        = distinct(acme_certificate.cert.subject_alternative_names)
  cert_sans_sorted = sort(local.cert_sans)
}

output "acme_account_key" {
  description = "Private key for ACME account"
  value       = acme_certificate.cert.account_key_pem
  sensitive   = true
}

output "acme_account_key_fingerprint" {
  description = "Fingerprint for ACME account key (in MD5)"
  value       = var.acme_account_key_fingerprint
}

output "acme_cert_id" {
  description = "Certificate identifier within the ACME CA"
  value       = acme_certificate.cert.id
}

// Optimistically unique request ID (calculated based on the account, CN and SANs)
output "cert_request_id" {
  description = "Certificate request identifier"
  value = sha256(join(",", [
    var.acme_account_key_fingerprint,
    var.cert_description,
    var.cert_key_type,
    acme_certificate.cert.common_name,
    join(",", local.cert_sans_sorted)
  ]))
}

output "cert_description" {
  description = "Friendly description of the certificate request"
  value       = var.cert_description
}

output "cert_request_cn" {
  description = "Certificate common name"
  value       = acme_certificate.cert.common_name
}

output "cert_request_sans" {
  description = "Certificate subject alternative names (SANs)"
  value       = local.cert_sans
}

output "cert_private_key" {
  description = "Certificate private key"
  value       = trimspace(acme_certificate.cert.private_key_pem)
  sensitive   = true
}

output "cert_leaf" {
  description = "Leaf certificate"
  value       = trimspace(acme_certificate.cert.certificate_pem)
}

output "cert_intermediate" {
  description = "Intermediate certificate"
  value       = trimspace(acme_certificate.cert.issuer_pem)
}

output "cert_fullchain_pem" {
  description = "Certificate full chain in PEM format"
  value = join("", [
    acme_certificate.cert.certificate_pem,
    acme_certificate.cert.issuer_pem,
  ])
}

output "cert_fullchain_p12" {
  description = "Certificate full chain and private key in PKCS12 format"
  value       = trimspace(acme_certificate.cert.certificate_p12)
  sensitive   = true
}
