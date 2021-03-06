terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.5.1"
    }
  }
}

module "cluster" {
    source = "../../../digitalocean/context"
    cluster_name = var.cluster_name
}

provider "digitalocean" {
  token = var.digitalocean_token
}

variable "digitalocean_token" {
}

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
  source = "../../verifier"
  namespace = "test2"
}

output "hello" {
  value = module.verification.hello
}