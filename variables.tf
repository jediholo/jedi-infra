// OVH provider
variable "ovh_endpoint" {
  description = "OVH API endpoint"
}
variable "ovh_application_key" {
  description = "OVH application key"
  sensitive   = true
}
variable "ovh_application_secret" {
  description = "OVH application secret"
  sensitive   = true
}
variable "ovh_consumer_key" {
  description = "OVH consumer key"
  sensitive   = true
}

// OpenStack provider
variable "os_auth_url" {
  description = "OpenStack authentication URL"
}
variable "os_region" {
  description = "OpenStack region name"
}
variable "os_tenant" {
  description = "OpenStack tenant name"
}
variable "os_username" {
  description = "OpenStack username"
}
variable "os_password" {
  description = "OpenStack password"
  sensitive   = true
}

// Google Cloud provider
variable "gcp_credentials" {
  description = "Terraform service account credentials JSON file"
  sensitive   = true
}
variable "gcp_project_id" {
  description = "GCP project ID"
}
variable "gcp_region" {
  description = "GCP region"
}

// Kubernetes provider
variable "k8s_host" {
  description = "Kubernetes master host name"
}
variable "k8s_client_cert" {
  description = "Kubernetes client certificate (base64-encoded PEM)"
}
variable "k8s_client_key" {
  description = "Kubernetes client private key (base64-encoded PEM)"
  sensitive   = true
}
variable "k8s_ca_cert" {
  description = "Kubernetes cluster CA certificate (base64-encoded PEM)"
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

// Discord interaction
variable "discord_client_public_key" {
  description = "Discord bot public key"
  sensitive   = true
}
variable "discord_webhook_id" {
  description = "Discord webhook ID"
}
variable "discord_webhook_token" {
  description = "Discord webhook token"
  sensitive   = true
}
variable "discord_admin_role_id" {
  description = "Discord admin role ID (comma-separated list)"
}

// JKA
variable "jka_namespace" {
  description = "JKA Kubernetes namespace"
}
variable "jka_external_ip" {
  description = "External IP address"
}
variable "jka_deployments_scale_sa" {
  default = []
  type = list(object({
    name      = string
    namespace = string
  }))
  description = "JKA deployments scale service account(s)"
}
variable "jka_server_hostport" {
  type        = map(string)
  description = "JKA server host:port"
}
variable "jka_server_password" {
  type        = map(string)
  description = "JKA server password (g_password)"
  sensitive   = true
}
variable "jka_rcon_password" {
  type        = map(string)
  description = "JKA Rcon password (rconpassword)"
  sensitive   = true
}
variable "jka_am_password" {
  type        = map(string)
  description = "JKA AccountManager password (rp_accounts_AM_servicePassword)"
  sensitive   = true
}
variable "jka_backups_openrc" {
  description = "OpenStack openrc file for backups"
  sensitive   = true
}
variable "jka_backups_sa" {
  description = "Google Service Account JSON key for backups"
  sensitive   = true
}

// Web
variable "web_namespace" {
  description = "Web Kubernetes namespace"
}
variable "web_backups_openrc" {
  description = "OpenStack openrc file for backups"
  sensitive   = true
}
variable "web_backups_sa" {
  description = "Google Service Account JSON key for backups"
  sensitive   = true
}
variable "web_backups_ftp_username" {
  description = "FTP username for backups"
}
variable "web_backups_ftp_password" {
  description = "FTP password for backups"
  sensitive   = true
}
variable "web_backups_mysql_username" {
  description = "MySQL username for backups"
}
variable "web_backups_mysql_password" {
  description = "MySQL password for backups"
  sensitive   = true
}
variable "web_activemq_admin_password" {
  description = "ActiveMQ admin password"
  sensitive   = true
}
variable "web_ldap_root_password" {
  description = "LDAP root password"
  sensitive   = true
}
variable "web_mailserver_dkim_private_key" {
  description = "DKIM private key (PEM-encoded)"
  sensitive   = true
}
variable "web_mysql_root_password" {
  description = "MySQL root password"
  sensitive   = true
}

// Uptime checks
variable "uptime_check_urls" {
  default     = []
  type        = list(string)
  description = "Uptime check HTTPS URLs"
}
variable "uptime_check_notification_email" {
  description = "Uptime check notification email address"
}
