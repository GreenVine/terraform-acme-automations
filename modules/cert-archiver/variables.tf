// Mandatory variables
variable "storage_bucket" {
  description = "The Google Cloud Storage bucket name for certificate storage"
  type        = string
}

variable "acme_cert_id" {
  description = "Certificate identifier within the ACME CA"
  type        = string
}

variable "cert_request_id" {
  description = "Certificate request identifier"
  type        = string
}

variable "cert_private_key" {
  description = "Certificate private key"
  type        = string
}

variable "cert_leaf" {
  description = "Leaf certificate"
  type        = string
}

variable "cert_intermediate" {
  description = "Intermediate certificate"
  type        = string
}

variable "cert_fullchain_pem" {
  description = "Certificate full chain in PEM format"
  type        = string
}

variable "cert_fullchain_p12" {
  description = "Certificate full chain and private key in PKCS12 format"
  type        = string
}

// Optional variables
variable "acme_account_fingerprint" {
  description = "ACME account fingerprint"
  type        = string
  default     = ""
}

variable "storage_prefix" {
  description = "The object prefix for all archives"
  type        = string
  default     = ""
}

// Non-essential variables (for tracking purpose only)
variable "cert_cn" {
  description = "Certificate common name"
  type        = string
  default     = ""
}

variable "cert_sans" {
  description = "Certificate subject alternative names (SANs)"
  type        = list(string)
  default     = []
}
