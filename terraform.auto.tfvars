# OVH provider
ovh_endpoint = "ovh-eu"
#ovh_application_key = "toComplete"
#ovh_application_secret = "toComplete"
#ovh_consumer_key = "toComplete"

# OpenStack provider
os_auth_url = "https://auth.cloud.ovh.net/v3/"
os_region = "GRA"
#os_tenant = "toComplete"
#os_username = "toComplete"
#os_password = "toComplete"

# GCP provider
#gcp_credentials = "toComplete"
gcp_project_id = "jediholo-net"
gcp_region = "europe-west1"

# Grafana provider
grafana_url = "https://fabinfra.grafana.net/"
#grafana_auth = "toComplete"
grafana_sm_url = "https://synthetic-monitoring-api.grafana.net"
#grafana_sm_access_token = "toComplete"

# Kubernetes provider
k8s_host = "https://k8s-master.vpn.fabinfra.net:6443"
#k8s_client_cert = "toComplete"
#k8s_client_key = "toComplete"
#k8s_ca_cert = "toComplete"

# DNS config
dns_zone = "jediholo.net"
dns_records = [
  { name = "",                      ttl = 0,     type = "A",      target = "51.255.79.178" },
  { name = "",                      ttl = 0,     type = "AAAA",   target = "2001:41d0:203:2b2::1" },
  { name = "",                      ttl = 0,     type = "CAA",    target = "128 issue \"letsencrypt.org\"" },
  { name = "",                      ttl = 0,     type = "MX",     target = "1 mx4.mail.ovh.net." },
  { name = "",                      ttl = 0,     type = "MX",     target = "10 mx3.mail.ovh.net." },
  { name = "",                      ttl = 600,   type = "SPF",    target = "\"v=spf1 a:ks11.srv.fabinfra.net a:ks13.srv.fabinfra.net a:sy03.srv.fabinfra.net include:mx.ovh.com ?all\"" },
  { name = "",                      ttl = 0,     type = "TXT",    target = "\"google-site-verification=_20vklpumKjTDIdPh0jiFaUlXiVl4ho56OS6ZwJQNqs\"" },
  { name = "_dmarc",                ttl = 0,     type = "DMARC",  target = "v=DMARC1;p=none;rua=mailto:postmaster@jediholo.net;" },
  { name = "comport",               ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "comport.dev",           ttl = 300,   type = "A",      target = "127.0.0.12" },
  { name = "demo",                  ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "discord",               ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "files",                 ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "ftp",                   ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "galaxy",                ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "grounds",               ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "jka06",                 ttl = 1800,  type = "CNAME",  target = "ipv4.ks11.srv.fabinfra.net." },
  { name = "march2016._domainkey",  ttl = 0,     type = "DKIM",   target = "k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwvjrMuYA4hkI0TMzk6h4Hec06Unn/qZUxf4YnR5OWkCYrlIJZXuOUIsYZMXTiXCEhPdO6JktOcdVcUyB8UdhGLv7PoMShG+Kb9zsfqOtLJ3dfzJuaBsoV0BEi4yLqXPTNqbzE4YtxynC11MfPrtxwIYmJ5p4S2RMztBTZC5g/1PoQ2UWk/NphEzO6iA4Bbtas1OD+44Moa1OYMbi3YZrmEn1WTfrWodunAYE92Usoj+kpSiBqhYPS/r8iQMOsRZOznDZhxG7VIYGU5xq+Ah0hpWoU/Nvs79LBP0pgC7vyCRXec18Q7Ix3t7WaYOZv5/GfhbcWREM0wVAsEQYjVp9cwIDAQAB;t=s;" },
  { name = "rpmod",                 ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "rpmod.dev",             ttl = 300,   type = "A",      target = "127.0.0.13" },
  { name = "services",              ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "srv01",                 ttl = 1800,  type = "CNAME",  target = "k8s.fabinfra.net." },
  { name = "static",                ttl = 1800,  type = "CNAME",  target = "jediholo.github.io." },
  { name = "static.dev",            ttl = 300,   type = "A",      target = "127.0.0.10" },
  { name = "temple",                ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "www",                   ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "www.dev",               ttl = 300,   type = "A",      target = "127.0.0.11" },
]

# Discord interaction
#discord_client_public_key = "toComplete"
#discord_webhook_id = "toComplete"
#discord_webhook_token = "toComplete"
#discord_admin_role_id = "toComplete"

# Jedi Academy
jka_namespace = "jka"
jka_external_ip = "37.187.118.231"
jka_deployments_scale_sa = [
  { name = "rpmod", "namespace" = "domain-jediholo-net" },
]
jka_server_hostport = {
  "jedi-temple"  = "temple.jediholo.net:29070"
  "jedi-grounds" = "grounds.jediholo.net:29071"
  "jedi-demo"    = "demo.jediholo.net:29072"
  "jedi-galaxy"  = "galaxy.jediholo.net:29073"
}
#jka_server_password = {
#  "jedi-demo" = "toComplete"
#}
#jka_rcon_password = {
#  "default" = "toComplete"
#}
#jka_am_password = {
#  "jedi-temple"  = "toComplete"
#  "jedi-grounds" = "toComplete"
#  "jedi-demo"    = "toComplete"
#  "jedi-galaxy"  = "toComplete"
#}
#jka_ftp_password = {
#  "default" = "toComplete"
#}
#jka_backups_openrc = "toComplete"
#jka_backups_sa = "toComplete"

# Web
web_namespace = "domain-jediholo-net"
#web_backups_openrc = "toComplete"
#web_backups_sa = "toComplete"
#web_backups_mysql_username = "toComplete"
#web_backups_mysql_password = "toComplete"
#web_activemq_admin_password = "toComplete"
#web_ldap_root_password = "toComplete"
#web_logstash_elasticsearch_ca = "toComplete"
#web_logstash_elasticsearch_password = "toComplete"
#web_mailserver_dkim_private_key = "toComplete"
#web_matomo_db_username = "toComplete"
#web_matomo_db_password = "toComplete"
#web_matomo_salt = "toComplete"
#web_mysql_root_password = "toComplete"
#web_phpbb_db_username = "toComplete"
#web_phpbb_db_password = "toComplete"
#web_rpmod_application_config = "toComplete"
#web_rpmod_gameasset_private_key = "toComplete"
#web_rpmod_gameasset_public_key = "toComplete"
#web_rpmod_oidc_jwks = "toComplete"
#web_rpmod_oidc_private_key = "toComplete"
#web_rpmod_oidc_public_key = "toComplete"
#web_wordpress_db_username = "toComplete"
#web_wordpress_db_password = "toComplete"
#web_wordpress_auth_key = "toComplete"
#web_wordpress_secure_auth_key = "toComplete"
#web_wordpress_logged_in_key = "toComplete"
#web_wordpress_nonce_key = "toComplete"
#web_wordpress_auth_salt = "toComplete"
#web_wordpress_secure_auth_salt = "toComplete"
#web_wordpress_logged_in_salt = "toComplete"
#web_wordpress_nonce_salt = "toComplete"

# Uptime checks
uptime_check_urls = [
 "https://comport.jediholo.net/",
 "https://files.jediholo.net/",
 "https://rpmod.jediholo.net/",
 "https://static.jediholo.net/",
 "https://www.jediholo.net/",
]
