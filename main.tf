terraform {
  backend "http" {}
}

provider "acme" {
  server_url = var.acme_endpoint_directory
}

// Provision ACME account key pair
resource "tls_private_key" "account_key" {
  algorithm = var.acme_account_key_algo
}

// Register to ACME provider
resource "acme_registration" "acme_account" {
  account_key_pem = tls_private_key.account_key.private_key_pem
  email_address   = var.acme_account_email
}

// Request certificates with ACME manager module
module "acme_manager" {
  for_each = var.acme_cert_requests
  source   = "./modules/acme-manager"

  acme_account_key             = acme_registration.acme_account.account_key_pem
  acme_account_key_fingerprint = replace(tls_private_key.account_key.public_key_fingerprint_md5, ":", "")
  acme_dns_challenge_provider  = each.value.dns_challenge_provider
  acme_dns_challenge_config    = each.value.dns_challenge_config
  acme_recursive_ns            = var.acme_recursive_ns
  cert_description             = each.key
  cert_cn                      = each.value.cn
  cert_sans                    = each.value.sans
  cert_key_type                = each.value.key_type
  cert_ocsp_stapling           = each.value.ocsp_stapling
}

// Archive issued certificates and keys
module "cert_archiver" {
  for_each = module.acme_manager
  source   = "./modules/cert-archiver"

  storage_bucket = var.cert_storage_gcs_bucket
  storage_prefix = var.cert_storage_gcs_prefix

  acme_account_fingerprint = replace(tls_private_key.account_key.public_key_fingerprint_md5, ":", "")
  acme_cert_id             = each.value.acme_cert_id
  cert_description         = each.key
  cert_cn                  = each.value.cert_request_cn
  cert_sans                = each.value.cert_request_sans
  cert_request_id          = each.value.cert_request_id
  cert_private_key         = each.value.cert_private_key
  cert_leaf                = each.value.cert_leaf
  cert_intermediate        = each.value.cert_intermediate
  cert_fullchain_p12       = each.value.cert_fullchain_p12
  cert_fullchain_pem       = each.value.cert_fullchain_pem
}
