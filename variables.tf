// Mandatory variables
variable "acme_account_email" {
  description = "ACME provider account email"
  type        = string
}

variable "acme_cert_requests" {
  description = "List of certificate requests"
  type = map(object({
    cn                     = string
    sans                   = list(string)
    key_type               = string
    dns_challenge_provider = string
    dns_challenge_config   = map(string)
    ocsp_stapling          = bool
  }))
}

variable "cert_storage_gcs_bucket" {
  description = "The Google Cloud Storage bucket name for certificate storage"
  type        = string
}

// Optional variables
variable "acme_endpoint_directory" {
  description = "ACME provider directory URL"
  type        = string
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

variable "acme_account_key_algo" {
  description = "Certificate key algorithm"
  type        = string
  default     = "RSA"
}

variable "acme_recursive_ns" {
  description = "Recursive nameservers for DNS propagation check"
  type        = list(string)
  default     = []
}

variable "cert_storage_gcs_prefix" {
  description = "The object prefix for states"
  type        = string
  default     = ""
}
