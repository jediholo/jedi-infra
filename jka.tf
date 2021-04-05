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
  subject {
    kind      = "ServiceAccount"
    name      = var.jka_deployments_scale_sa_name
    namespace = var.jka_deployments_scale_sa_namespace
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.jka_role_deployments_scale.metadata[0].name
  }
}

// JKA servers
resource "helm_release" "jka_server" {
  for_each  = toset(var.jka_server_names)
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
