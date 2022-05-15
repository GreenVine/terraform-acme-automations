// Mandatory variables
variable "acme_account_key" {
  description = "ACME account private key (in PEM format)"
  type        = string
}

variable "acme_account_key_fingerprint" {
  description = "ACME account public key fingerprint (in MD5)"
  type        = string
}

variable "acme_dns_challenge_provider" {
  description = "Provider to be used for DNS challenge"
  type        = string
}

variable "acme_dns_challenge_config" {
  description = "Provider config for DNS challenge"
  type        = map(string)
}

variable "cert_cn" {
  description = "Certificate common name"
  type        = string
}

// Optional variables
variable "acme_recursive_ns" {
  description = "Recursive nameservers for DNS propagation check"
  type        = list(string)
  default = [
    "8.8.8.8:53",
    "1.1.1.1:53",
    "8.8.4.4:53",
  ]
}

variable "cert_sans" {
  description = "Certificate subject alternative names (SAN)"
  type        = list(string)
  default     = []
}

variable "cert_key_type" {
  description = "Certificate key type"
  type        = string
  default     = "2048"
}

variable "cert_ocsp_stapling" {
  description = "Enables the OCSP Stapling Required TLS Security Policy extension"
  type        = bool
  default     = false
}

variable "cert_description" {
  description = "Friendly description of the certificate request"
  type        = string
  default     = ""
}
