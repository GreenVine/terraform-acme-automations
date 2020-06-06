terraform {
  backend "gcs" {}
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
  acme_account_key_fingerprint = tls_private_key.account_key.public_key_fingerprint_md5
  acme_dns_challenge_provider  = each.value.dns_provider
  acme_recursive_ns            = var.acme_recursive_ns
  cert_cn                      = each.value.cn
  cert_sans                    = each.value.sans
}

// Archive issued certificates and keys
module "cert_archiver" {
  for_each = module.acme_manager
  source   = "./modules/cert-archiver"

  storage_bucket = var.cert_storage_gcs_bucket
  storage_prefix = var.cert_storage_gcs_prefix

  acme_account_fingerprint = tls_private_key.account_key.public_key_fingerprint_md5
  cert_request_id          = each.value.acme_request_id
  cert_provider_id         = each.value.acme_cert_id
  cert_private_key         = each.value.acme_cert_private_key
  cert_leaf                = each.value.acme_cert_leaf
  cert_intermediate        = each.value.acme_cert_intermediate
  cert_fullchain_p12       = each.value.acme_cert_fullchain_p12
  cert_fullchain_pem       = each.value.acme_cert_fullchain_pem
  cert_cn                  = each.value.acme_request_cn
  cert_sans                = each.value.acme_request_sans
}
