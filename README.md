# terraform-acme-automations

This repository maintains [Terraform](https://terraform.io) script to automatically request, renew and store SSL certificates. It's intended to work with [Automatic Certificate Management Environment (ACME)](https://en.wikipedia.org/wiki/Automated_Certificate_Management_Environment) compatible providers, most notably, [Let's Encrypt](https://letsencrypt.org/).

The script includes dependent modules which are intended to be reusable. `acme-manager` is for interacting with ACME API whereas `cert-archiver` is for certificate storage.

## Prerequisites

Terraform v0.13+

## Usage

The script is configurable via `terraform.tfvars` file. To issue certificate, add one or more certificate requests in the `acme_cert_requests` section.

Refer to `terraform.example.tfvars` for full configuration options.

```terraform
### Account email to be registered with ACME provider ###
acme_account_email = "myaccount@example.com"

### Populate list of certificate requests below ###
acme_cert_requests = {
  "awesome_website_1" = {
    # Common name
    cn            = "*.example.com",
    # Subject alternative names (SANs)
    sans          = [
      "*.awesome.example.com",
    ],
    # RSA / ECDSA key length
    key_type      = "2048",
    # DNS provider for DNS-01 challenge
    dns_provider  = "gcloud",
    # Enables the OCSP Stapling Required TLS extension
    ocsp_stapling = false,
  }
}

### Certificate backend storage (GCS) ###
cert_storage_gcs_bucket = "my-bucket"
cert_storage_gcs_prefix = "prefix/to/certificates"
```

## Storage

The module `cert-archiver` manages private keys and certificates and uploads them to object storage services. [Google Cloud Storage (GCS)](https://cloud.google.com/storage) is supported by default but is interchangeable with any storage providers.

## Reference

- Terraform ACME Provider: https://www.terraform.io/docs/providers/acme/index.html
- Terraform Google Cloud Storage: https://www.terraform.io/docs/providers/google/r/storage_bucket_object.html
- Let's Encrypt: https://letsencrypt.org
