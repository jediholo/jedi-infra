// OVH provider
variable "ovh_endpoint" {
  description = "OVH API endpoint"
}
variable "ovh_application_key" {
  description = "OVH application key"
}
variable "ovh_application_secret" {
  description = "OVH application secret"
}
variable "ovh_consumer_key" {
  description = "OVH consumer key"
}

// DNS config
variable "dns_zone" {
  description = "DNS zone name"
}
variable "dns_records" {
  default = []
  type = list(object({
    name   = string
    ttl    = number
    type   = string
    target = string
  }))
  description = "DNS records"
}

// Google Cloud provider
variable "gcp_credentials" {
  description = "Terraform service account credentials JSON file"
}
variable "gcp_project_id" {
  description = "GCP project ID"
}
variable "gcp_region" {
  description = "GCP region"
}

// Discord interaction
variable "discord_client_public_key" {
  description = "Discord bot public key"
}
variable "discord_webhook_id" {
  description = "Discord webhook ID"
}
variable "discord_webhook_token" {
  description = "Discord webhook token"
}
variable "discord_admin_role_id" {
  description = "Discord admin role ID (comma-separated list)"
}
