terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    google = {
      source = "hashicorp/google"
      version = "3.58.0"
    }
  }
}

module "cluster" {
    source = "../../gke"
    cluster_name = var.cluster_name
}

provider "google" {
  credentials = base64decode(var.gcloud_credentials_base64)
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

variable "gcloud_credentials_base64" {}

variable "cluster_name" {
}

provider "kubernetes" {
    config_path = lookup(module.cluster.kubernetes, "config_path", null)
    host     = lookup(module.cluster.kubernetes, "host", null)
    username = lookup(module.cluster.kubernetes, "username", null)
    password = lookup(module.cluster.kubernetes, "password", null)
    cluster_ca_certificate = lookup(module.cluster.kubernetes, "cluster_ca_certificate", null)
    token = lookup(module.cluster.kubernetes, "token", null)
    client_certificate = lookup(module.cluster.kubernetes, "client_certificate", null)
    client_key = lookup(module.cluster.kubernetes, "client_key", null)
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}