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
variable "ovh_project_id" {
  description = "OVH public cloud project ID"
}
variable "ovh_region" {
  description = "OVH public cloud region"
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

// Grafana provider
variable "grafana_url" {
  description = "Grafana URL"
}
variable "grafana_auth" {
  description = "Grafana API key"
  sensitive   = true
}
variable "grafana_sm_url" {
  description = "Grafana Synthetic Monitoring URL"
}
variable "grafana_sm_access_token" {
  description = "Grafana Synthetic Monitoring access token"
  sensitive   = true
}

// Kubernetes provider
variable "k8s_host" {
  description = "Kubernetes master host name"
}
variable "k8s_ca_cert" {
  description = "Kubernetes cluster CA certificate (base64-encoded PEM)"
}
variable "k8s_token" {
  description = "Kubernetes service account token"
  sensitive   = true
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
variable "jka_ftp_password" {
  type        = map(string)
  description = "JKA FTP password"
  sensitive   = true
}
variable "jka_sftpgo_admin_password" {
  description = "SFTPGo admin password"
  sensitive   = true
}
variable "jka_uptime_check_enabled" {
  type        = map(bool)
  description = "JKA uptime check toggle"
}
variable "jka_backups_openrc" {
  description = "OpenStack openrc file for backups"
  sensitive   = true
}
variable "jka_backups_sa" {
  description = "Google Service Account JSON key for backups"
  sensitive   = true
}

// Storage
variable "storage_bucket_prefix" {
  description = "Storage buckets prefix"
}
variable "storage_bucket_names" {
  default     = []
  type        = list(string)
  description = "Storage bucket names (excluding prefix)"
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
variable "web_backups_s3_access_key_id" {
  description = "Amazon S3 Access Key ID"
  sensitive   = true
}
variable "web_backups_s3_secret_access_key" {
  description = "Amazon S3 Secret Access Key"
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
variable "web_logstash_elasticsearch_ca" {
  description = "Logstash Elasticsearch certificate authority (PEM-encoded)"
  sensitive   = true
}
variable "web_logstash_elasticsearch_password" {
  description = "Logstash Elasticsearch password"
  sensitive   = true
}
variable "web_mailserver_dkim_private_key" {
  description = "DKIM private key (PEM-encoded)"
  sensitive   = true
}
variable "web_matomo_db_username" {
  description = "Matomo database username"
}
variable "web_matomo_db_password" {
  description = "Matomo database password"
  sensitive   = true
}
variable "web_matomo_salt" {
  description = "Matomo authentication salt"
  sensitive   = true
}
variable "web_mysql_root_password" {
  description = "MySQL root password"
  sensitive   = true
}
variable "web_phpbb_db_username" {
  description = "phpBB database username"
}
variable "web_phpbb_db_password" {
  description = "phpBB database password"
  sensitive   = true
}
variable "web_rpmod_db_url" {
  description = "RPMod Web database URL (e.g. mysql://user:pass@dbhost/dbname)"
  sensitive   = true
}
variable "web_rpmod_discord_pubkey" {
  description = "RPMod Web Discord interaction public key"
  sensitive   = true
}
variable "web_rpmod_gameasset_private_key" {
  description = "RPMod Web GameAsset private key (PEM-encoded)"
  sensitive   = true
}
variable "web_rpmod_gameasset_public_key" {
  description = "RPMod Web GameAsset public key (PEM-encoded)"
  sensitive   = true
}
variable "web_rpmod_oidc_jwks" {
  description = "RPMod Web OpenID Connect JSON Web Key Set (JWKS)"
  sensitive   = true
}
variable "web_rpmod_oidc_private_key" {
  description = "RPMod Web OpenID Connect private key (PEM-encoded)"
  sensitive   = true
}
variable "web_rpmod_oidc_public_key" {
  description = "RPMod Web OpenID Connect public key (PEM-encoded)"
  sensitive   = true
}
variable "web_rpmod_recaptcha_pubkey" {
  description = "RPMod Web reCAPTCHA public key"
  sensitive   = true
}
variable "web_rpmod_recaptcha_privkey" {
  description = "RPMod Web reCAPTCHA private key"
  sensitive   = true
}
variable "web_wordpress_db_username" {
  description = "Wordpress database username"
}
variable "web_wordpress_db_password" {
  description = "Wordpress database password"
  sensitive   = true
}
variable "web_wordpress_auth_key" {
  description = "Wordpress auth key"
  sensitive   = true
}
variable "web_wordpress_secure_auth_key" {
  description = "Wordpress secure auth key"
  sensitive   = true
}
variable "web_wordpress_logged_in_key" {
  description = "Wordpress logged in key"
  sensitive   = true
}
variable "web_wordpress_nonce_key" {
  description = "Wordpress nonce key"
  sensitive   = true
}
variable "web_wordpress_auth_salt" {
  description = "Wordpress auth salt"
  sensitive   = true
}
variable "web_wordpress_secure_auth_salt" {
  description = "Wordpress secure auth salt"
  sensitive   = true
}
variable "web_wordpress_logged_in_salt" {
  description = "Wordpress logged in salt"
  sensitive   = true
}
variable "web_wordpress_nonce_salt" {
  description = "Wordpress nonce salt"
  sensitive   = true
}

// Uptime checks
variable "uptime_check_urls" {
  default     = []
  type        = list(string)
  description = "Uptime check HTTPS URLs"
}
variable "uptime_frequency" {
  description = "Uptime check frequency (ms)"
}
variable "uptime_timeout" {
  description = "Uptime check timeout (ms)"
}
