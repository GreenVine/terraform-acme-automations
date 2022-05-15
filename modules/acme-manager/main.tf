resource "acme_certificate" "cert" {
  account_key_pem           = var.acme_account_key
  key_type                  = var.cert_key_type
  common_name               = var.cert_cn
  subject_alternative_names = var.cert_sans
  must_staple               = var.cert_ocsp_stapling

  recursive_nameservers = length(var.acme_recursive_ns) > 0 ? var.acme_recursive_ns : null

  dns_challenge {
    provider = var.acme_dns_challenge_provider
    config   = var.acme_dns_challenge_config
  }
}
