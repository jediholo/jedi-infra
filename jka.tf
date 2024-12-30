// Kubernetes namespace
resource "kubernetes_namespace" "jka_ns" {
  metadata {
    name = var.jka_namespace
    labels = {
      "name" = var.jka_namespace
    }
  }
}

// Deployments scale role
resource "kubernetes_role" "jka_role_deployments_scale" {
  metadata {
    name      = "role-deployments-scale"
    namespace = kubernetes_namespace.jka_ns.metadata[0].name
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "deployments/scale"]
    verbs      = ["get", "patch"]
  }
}

// Deployments scale role binding
resource "kubernetes_role_binding" "jka_rolebinding_deployments_scale" {
  metadata {
    name      = "rolebinding-deployments-scale"
    namespace = kubernetes_namespace.jka_ns.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.jka_role_deployments_scale.metadata[0].name
  }
  dynamic "subject" {
    for_each = { for sa in var.jka_deployments_scale_sa : sha1("${sa.name}_${sa.namespace}") => sa }
    content {
      kind      = "ServiceAccount"
      name      = subject.value.name
      namespace = subject.value.namespace
    }
  }
}

// JKA servers
resource "helm_release" "jka_server" {
  for_each  = toset(keys(var.jka_server_hostport))
  name      = each.value
  chart     = "${path.module}/jka/charts/jka"
  namespace = kubernetes_namespace.jka_ns.metadata[0].name

  values = [file("${path.module}/jka/values/${each.value}.yaml")]

  set {
    name  = "service.externalIPs[0]"
    value = var.jka_external_ip
  }
  set {
    name  = "jka.cvars.g_password"
    value = lookup(var.jka_server_password, each.value, lookup(var.jka_server_password, "default", ""))
  }
  set {
    name  = "jka.cvars.rconpassword"
    value = lookup(var.jka_rcon_password, each.value, lookup(var.jka_rcon_password, "default", ""))
  }
  set {
    name  = "jka.cvars.rp_accounts_AM_servicePassword"
    value = lookup(var.jka_am_password, each.value, lookup(var.jka_am_password, "default", ""))
  }
}

// Backups
resource "helm_release" "jka_backups" {
  name      = "backups"
  chart     = "${path.module}/jka/charts/backups"
  namespace = kubernetes_namespace.jka_ns.metadata[0].name

  values = [file("${path.module}/jka/values/backups.yaml")]

  set_sensitive {
    name  = "secrets.swift.openrc"
    value = var.jka_backups_openrc
  }
  set_sensitive {
    name  = "secrets.gcs.sa"
    value = base64encode(var.jka_backups_sa)
  }
}

// Filebeat
resource "helm_release" "jka_filebeat" {
  name      = "filebeat"
  chart     = "${path.module}/jka/charts/filebeat"
  namespace = kubernetes_namespace.jka_ns.metadata[0].name

  values = [file("${path.module}/jka/values/filebeat.yaml")]
}

// SFTPGo
resource "helm_release" "jka_sftpgo" {
  name      = "sftpgo"
  chart     = "${path.module}/jka/charts/sftpgo"
  namespace = kubernetes_namespace.jka_ns.metadata[0].name

  values = [file("${path.module}/jka/values/sftpgo.yaml")]

  set_sensitive {
    name  = "env.SFTPGO_DEFAULT_ADMIN_PASSWORD"
    value = var.jka_sftpgo_admin_password
  }
  set {
    name  = "service.ftp.externalIPs[0]"
    value = var.jka_external_ip
  }
  set {
    name  = "service.sftp.externalIPs[0]"
    value = var.jka_external_ip
  }
  set {
    name  = "config.ftpd.bindings[0].port"
    value = "2121"
  }
  set {
    name  = "config.ftpd.bindings[0].force_passive_ip"
    value = var.jka_external_ip
  }
  dynamic "set" {
    for_each = { for i, v in keys(var.jka_server_hostport) : i => v }
    content {
      name  = "initdata.users[${set.key}].status"
      value = "1"
    }
  }
  dynamic "set" {
    for_each = { for i, v in keys(var.jka_server_hostport) : i => v }
    content {
      name  = "initdata.users[${set.key}].username"
      value = set.value
    }
  }
  dynamic "set" {
    for_each = { for i, v in keys(var.jka_server_hostport) : i => v }
    content {
      name  = "initdata.users[${set.key}].password"
      value = "\\{SHA512\\}${sha512(lookup(var.jka_ftp_password, set.value, lookup(var.jka_ftp_password, "default", "")))}"
    }
  }
  dynamic "set" {
    for_each = { for i, v in keys(var.jka_server_hostport) : i => v }
    content {
      name  = "initdata.users[${set.key}].permissions./[0]"
      value = "*"
    }
  }
  dynamic "set" {
    for_each = { for i, v in keys(var.jka_server_hostport) : i => v }
    content {
      name  = "initdata.users[${set.key}].groups[0].name"
      value = "jka"
    }
  }
  dynamic "set" {
    for_each = { for i, v in keys(var.jka_server_hostport) : i => v }
    content {
      name  = "initdata.users[${set.key}].groups[0].type"
      value = "1"
    }
  }
}

// Uptime checks
resource "grafana_synthetic_monitoring_check" "jka_uptime_check" {
  for_each          = var.jka_server_hostport
  job               = replace(each.value, "/:.*$/", "")
  target            = "https://rpmod.jediholo.net/ws/ServerService/rest?method=GetInfo&host=${replace(each.value, "/:.*$/", "")}&port=${replace(each.value, "/^.*:/", "")}"
  enabled           = lookup(var.jka_uptime_check_enabled, each.key, true)
  frequency         = var.uptime_frequency
  timeout           = var.uptime_timeout
  alert_sensitivity = "medium"
  probes = [
    data.grafana_synthetic_monitoring_probes.sm_probes.probes.Paris
  ]
  labels = {
    domain = replace(each.value, "/(^[^.]+\\.|:.*$)/", "")
  }
  settings {
    http {
      fail_if_body_not_matches_regexp = [".*<status>success</status>.*"]
    }
  }
}
