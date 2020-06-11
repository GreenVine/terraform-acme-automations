locals {
  acme_cert_lists = flatten([for cert_description, cert_response in module.acme_manager : {
    "${cert_description}" = {
      acme_cert_id       = cert_response.acme_cert_id
      cert_request_id    = cert_response.cert_request_id
      cert_request_cn    = cert_response.cert_request_cn
      cert_request_sans  = cert_response.cert_request_sans
      cert_leaf          = cert_response.cert_leaf
      cert_intermediate  = cert_response.cert_intermediate
      cert_fullchain_pem = cert_response.cert_fullchain_pem
    }
  }])

  # convert acme_cert_lists to key-value map
  acme_cert_map = {for item in local.acme_cert_lists: keys(item)[0] => values(item)[0]}
}

output "acme_account_id" {
  description = "ACME account ID"
  value       = acme_registration.acme_account.id
}

output "acme_account_fingerprint" {
  description = "ACME account public key fingerprint (in MD5)"
  value       = replace(tls_private_key.account_key.public_key_fingerprint_md5, ":", "")
}

output "acme_cert_responses" {
  description = "ACME certificate responses"
  value       = local.acme_cert_map
}
