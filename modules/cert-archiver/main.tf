locals {
  archiving_objects = {
    "cert.key"         = var.cert_private_key
    "leaf.crt"         = var.cert_leaf
    "intermediate.crt" = var.cert_intermediate
    "fullchain.p12"    = var.cert_fullchain_p12
    "fullchain.pem"    = var.cert_fullchain_pem
  }
}

resource "google_storage_bucket_object" "objects_archive" {
  for_each = local.archiving_objects

  bucket       = var.storage_bucket
  name         = "${trim(var.storage_prefix, "/\\")}/${var.cert_request_id}/${each.key}"
  content      = each.value
  content_type = "text/plain; charset=utf-8"
  metadata     = {
    "x-acme-account-id"  = var.acme_account_fingerprint
    "x-acme-cert-id"     = var.acme_cert_id
    "x-acme-request-id"  = var.cert_request_id
    "x-cert-common-name" = var.cert_cn
    "x-cert-sans"        = join(",", var.cert_sans)
  }
}
