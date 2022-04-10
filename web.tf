// Kubernetes namespace
resource "kubernetes_namespace" "web_ns" {
  metadata {
    name = var.web_namespace
    labels = {
      "name" = var.web_namespace
    }
  }
}

// Network policy for pods in same namespace
resource "kubernetes_network_policy" "web_network_policy_same_ns" {
  metadata {
    name      = "allow-same-namespace"
    namespace = kubernetes_namespace.web_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
    }
    ingress {
      from {
        pod_selector {
        }
      }
    }
  }
}

// Network policy for ingress nginx
resource "kubernetes_network_policy" "web_network_policy_ingress_nginx" {
  metadata {
    name      = "allow-ingress-nginx"
    namespace = kubernetes_namespace.web_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = "ingress-nginx"
          }
        }
      }
    }
  }
}

// Network policy for ActiveMQ from JKA Logstash
resource "kubernetes_network_policy" "web_network_policy_activemq_jka_logstash" {
  metadata {
    name      = "allow-activemq-from-jka-logstash"
    namespace = kubernetes_namespace.web_ns.metadata[0].name
  }
  spec {
    policy_types = ["Ingress"]
    pod_selector {
      match_labels = {
        "app.kubernetes.io/name" = "activemq"
      }
    }
    ingress {
      from {
        namespace_selector {
          match_labels = {
            "name" = var.jka_namespace
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "logstash"
          }
        }
      }
    }
  }
}

// Backups
resource "helm_release" "web_backups" {
  name      = "backups"
  chart     = "${path.module}/web/charts/backups"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/backups.yaml")]

  set_sensitive {
    name  = "secrets.swift.openrc"
    value = var.web_backups_openrc
  }
  set_sensitive {
    name  = "secrets.gcs.sa"
    value = base64encode(var.web_backups_sa)
  }
  set_sensitive {
    name  = "secrets.ftp.username"
    value = var.web_backups_ftp_username
  }
  set_sensitive {
    name  = "secrets.ftp.password"
    value = var.web_backups_ftp_password
  }
  set_sensitive {
    name  = "secrets.mysql.username"
    value = var.web_backups_mysql_username
  }
  set_sensitive {
    name  = "secrets.mysql.password"
    value = var.web_backups_mysql_password
  }
}

// ActiveMQ broker
resource "helm_release" "web_activemq" {
  name      = "activemq"
  chart     = "${path.module}/web/charts/activemq"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/activemq.yaml")]

  set_sensitive {
    name  = "secrets.admin.password"
    value = var.web_activemq_admin_password
  }
}

// Apache web server
resource "helm_release" "web_apache" {
  name      = "apache"
  chart     = "${path.module}/web/charts/apache"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/apache.yaml")]
}

// LDAP directory
resource "helm_release" "web_ldap" {
  name      = "ldap"
  chart     = "${path.module}/web/charts/ldap"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/ldap.yaml")]

  set_sensitive {
    name  = "secrets.root.password"
    value = var.web_ldap_root_password
  }
}

// Mail server (outbound only)
resource "helm_release" "web_mailserver" {
  name      = "mailserver"
  chart     = "${path.module}/web/charts/mailserver"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/mailserver.yaml")]

  set_sensitive {
    name  = "dkim.config.privateKey"
    value = var.web_mailserver_dkim_private_key
  }
}

// Matomo
resource "helm_release" "web_matomo" {
  name      = "matomo"
  chart     = "${path.module}/web/charts/matomo"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/matomo.yaml")]

  set_sensitive {
    name  = "config.database.username"
    value = var.web_matomo_db_username
  }
  set_sensitive {
    name  = "config.database.password"
    value = var.web_matomo_db_password
  }
  set_sensitive {
    name  = "config.General.salt"
    value = var.web_matomo_salt
  }
}

// Memcached cache server
resource "helm_release" "web_memcached" {
  name      = "memcached"
  chart     = "${path.module}/web/charts/memcached"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/memcached.yaml")]
}

// MySQL database
resource "helm_release" "web_mysql" {
  name      = "mysql"
  chart     = "${path.module}/web/charts/mysql"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/mysql.yaml")]

  set_sensitive {
    name  = "secrets.root.password"
    value = var.web_mysql_root_password
  }
}
resource "helm_release" "web_mysql_slave" {
  name      = "mysql-slave"
  chart     = "${path.module}/web/charts/mysql"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/mysql-slave.yaml")]
}

// PHP server
resource "helm_release" "web_php" {
  name      = "php"
  chart     = "${path.module}/web/charts/php"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/php.yaml")]
}

// phpMyAdmin
resource "helm_release" "web_phpmyadmin" {
  name      = "phpmyadmin"
  chart     = "${path.module}/web/charts/phpmyadmin"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/phpmyadmin.yaml")]
}

// RPMod Web
resource "helm_release" "web_rpmod" {
  name      = "rpmod"
  chart     = "${path.module}/web/charts/rpmod"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/rpmod.yaml")]

  set_sensitive {
    name  = "config.application.production.resources\\.doctrine\\.connections\\.rpmod\\.dsn"
    value = var.web_rpmod_db_url
  }
  set_sensitive {
    name  = "config.application.production.discord\\.pubkey"
    value = var.web_rpmod_discord_pubkey
  }
  set_sensitive {
    name  = "config.application.production.recaptcha\\.pubkey"
    value = var.web_rpmod_recaptcha_pubkey
  }
  set_sensitive {
    name  = "config.application.production.recaptcha\\.privkey"
    value = var.web_rpmod_recaptcha_privkey
  }
  set_sensitive {
    name  = "certificates.gameasset.privateKey"
    value = var.web_rpmod_gameasset_private_key
  }
  set_sensitive {
    name  = "certificates.gameasset.publicKey"
    value = var.web_rpmod_gameasset_public_key
  }
  set_sensitive {
    name  = "certificates.oidc.jwks"
    value = base64encode(var.web_rpmod_oidc_jwks)
  }
  set_sensitive {
    name  = "certificates.oidc.privateKey"
    value = var.web_rpmod_oidc_private_key
  }
  set_sensitive {
    name  = "certificates.oidc.publicKey"
    value = var.web_rpmod_oidc_public_key
  }
}

// Wordpress
resource "helm_release" "web_wordpress" {
  name      = "wordpress"
  chart     = "${path.module}/web/charts/wordpress"
  namespace = kubernetes_namespace.web_ns.metadata[0].name

  values = [file("${path.module}/web/values/wordpress.yaml")]

  set_sensitive {
    name  = "env.WORDPRESS_DB_USER"
    value = var.web_wordpress_db_username
  }
  set_sensitive {
    name  = "env.WORDPRESS_DB_PASSWORD"
    value = var.web_wordpress_db_password
  }
  set_sensitive {
    name  = "env.WORDPRESS_AUTH_KEY"
    value = var.web_wordpress_auth_key
  }
  set_sensitive {
    name  = "env.WORDPRESS_SECURE_AUTH_KEY"
    value = var.web_wordpress_secure_auth_key
  }
  set_sensitive {
    name  = "env.WORDPRESS_LOGGED_IN_KEY"
    value = var.web_wordpress_logged_in_key
  }
  set_sensitive {
    name  = "env.WORDPRESS_NONCE_KEY"
    value = var.web_wordpress_nonce_key
  }
  set_sensitive {
    name  = "env.WORDPRESS_AUTH_SALT"
    value = var.web_wordpress_auth_salt
  }
  set_sensitive {
    name  = "env.WORDPRESS_SECURE_AUTH_SALT"
    value = var.web_wordpress_secure_auth_salt
  }
  set_sensitive {
    name  = "env.WORDPRESS_LOGGED_IN_SALT"
    value = var.web_wordpress_logged_in_salt
  }
  set_sensitive {
    name  = "env.WORDPRESS_NONCE_SALT"
    value = var.web_wordpress_nonce_salt
  }
}
