### Account email to be registered with ACME provider ###
acme_account_email = "myaccount@example.com"

### Populate list of certificate requests below ###
acme_cert_requests = {
  "awesome_website_1" = {
    # Common name
    cn = "*.example.com",
    # Subject alternative names (SANs)
    sans = [
      "*.awesome.example.com",
    ],
    # RSA / ECDSA key length
    key_type = "2048",
    # DNS provider for DNS-01 challenge
    dns_challenge_provider = "gcloud",
    dns_challenge_config = {
      GCE_PROJECT = "awesome-gcp-project",
    },
    # Enables the OCSP Stapling Required TLS extension
    ocsp_stapling = false,
  },

  "awesome_website_2" = {
    cn                     = "*.example.net",
    key_type               = "P256",
    dns_challenge_provider = "route53",
    ocsp_stapling          = true,
  },
}

### Nameserver used for DNS propagation check ###
acme_recursive_ns = [
  # syntax: "server:port"
  "1.1.1.1:53",
  "208.67.222.222:5353"
]

### Certificate backend storage (GCS) ###
cert_storage_gcs_bucket = "my-bucket"
cert_storage_gcs_prefix = "prefix/to/certificates"
