terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "~> 0.36"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.54"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.84"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.16"
    }
    grafana = {
      source = "grafana/grafana"
      version = "~> 2.11"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}
