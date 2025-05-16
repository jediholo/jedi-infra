// OVH provider
provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

// OVH S3 AWS provider
provider "aws" {
  region     = var.ovh_s3_region
  access_key = var.ovh_s3_access_key
  secret_key = var.ovh_s3_secret_key

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  endpoints {
    s3 = var.ovh_s3_endpoint
  }
}

// Google Cloud provider
provider "google" {
  credentials = var.gcp_credentials
  project     = var.gcp_project_id
  region      = var.gcp_region
}

// Grafana provider
provider "grafana" {
  url             = var.grafana_url
  auth            = var.grafana_auth
  sm_url          = var.grafana_sm_url
  sm_access_token = var.grafana_sm_access_token
}

// Kubernetes provider
provider "kubernetes" {
  host                   = var.k8s_host
  cluster_ca_certificate = base64decode(var.k8s_ca_cert)
  token                  = var.k8s_token
}

// Helm provider
provider "helm" {
  kubernetes {
    host                   = var.k8s_host
    cluster_ca_certificate = base64decode(var.k8s_ca_cert)
    token                  = var.k8s_token
  }
}
