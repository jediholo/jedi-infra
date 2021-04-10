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
    name  = "image.repository"
    value = var.jka_image_name
  }
  set {
    name  = "image.tag"
    value = var.jka_image_tag
  }
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

// Uptime checks
resource "google_monitoring_uptime_check_config" "jka_uptime_check" {
  for_each     = toset(values(var.jka_server_hostport))
  display_name = replace(each.value, "/:.*$/", "")
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = "/ws/ServerService/rest?method=GetInfo&host=${replace(each.value, "/:.*$/", "")}&port=${replace(each.value, "/^.*:/", "")}"
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.gcp_project_id
      host       = "rpmod.jediholo.net"
    }
  }

  content_matchers {
    matcher = "CONTAINS_STRING"
    content = "<status>success</status>"
  }
}
