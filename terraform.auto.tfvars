# OVH provider
ovh_endpoint = "ovh-eu"
#ovh_application_key = "toComplete"
#ovh_application_secret = "toComplete"
#ovh_consumer_key = "toComplete"

# DNS config
dns_zone = "jediholo.net"
dns_records = [
  { name = "",                      ttl = 0,     type = "A",      target = "5.39.85.174" },
  { name = "",                      ttl = 0,     type = "AAAA",   target = "2001:41d0:8:97ae::1" },
  { name = "",                      ttl = 0,     type = "CAA",    target = "128 issue \"letsencrypt.org\"" },
  { name = "",                      ttl = 0,     type = "MX",     target = "1 mx4.mail.ovh.net." },
  { name = "",                      ttl = 0,     type = "MX",     target = "10 mx3.mail.ovh.net." },
  { name = "",                      ttl = 600,   type = "SPF",    target = "\"v=spf1 a:ks11.srv.fabinfra.net a:sy02.srv.fabinfra.net include:mx.ovh.com ?all\"" },
  { name = "",                      ttl = 0,     type = "TXT",    target = "\"google-site-verification=_20vklpumKjTDIdPh0jiFaUlXiVl4ho56OS6ZwJQNqs\"" },
  { name = "comport",               ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "comport.dev",           ttl = 300,   type = "A",      target = "127.0.0.12" },
  { name = "demo",                  ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "discord",               ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "files",                 ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "ftp",                   ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "galaxy",                ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "grounds",               ttl = 300,   type = "CNAME",  target = "jka06" },
  { name = "id",                    ttl = 1800,  type = "CNAME",  target = "srv01" },
  { name = "id.dev",                ttl = 300,   type = "A",      target = "127.0.0.14" },
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

# GCP provider
#gcp_credentials = "toComplete"
gcp_project_id = "jediholo-net"
gcp_region = "europe-west1"

# Discord interaction
#discord_client_public_key = "toComplete"
#discord_webhook_id = "toComplete"
#discord_webhook_token = "toComplete"
#discord_admin_role_id = "toComplete"
