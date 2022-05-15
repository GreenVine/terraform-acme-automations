locals {
  archiving_objects = {
    "cert.key"         = var.cert_private_key
    "leaf.pem"         = var.cert_leaf
    "intermediate.pem" = var.cert_intermediate
    "fullchain.p12"    = var.cert_fullchain_p12
    "fullchain.pem"    = var.cert_fullchain_pem
  }
}

resource "google_storage_bucket_object" "objects_archive" {
  for_each = local.archiving_objects

  bucket       = var.storage_bucket
  name         = "${var.storage_prefix}/${var.cert_description}/${var.acme_account_fingerprint}/${var.cert_request_id}/${each.key}"
  content      = each.value
  content_type = "text/plain; charset=utf-8"

  metadata = {
    "x-acme-account-id"  = var.acme_account_fingerprint
    "x-acme-cert-id"     = var.acme_cert_id
    "x-acme-request-id"  = var.cert_request_id
    "x-acme-cert-desc"   = var.cert_description
    "x-cert-common-name" = var.cert_cn
    "x-cert-sans"        = join(",", var.cert_sans)
    "x-content-md5"      = md5(each.value)
    "x-content-sha1"     = sha1(each.value)
    "x-content-sha256"   = sha256(each.value)
    "x-content-sha512"   = sha512(each.value)
  }
}
