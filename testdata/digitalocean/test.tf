module "cluster" {
    source = "../../digitalocean"
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
    load_config_file = lookup(module.cluster, "load_config_file", false)
    config_path = lookup(module.cluster, "config_path", null)
    host     = lookup(module.cluster, "host", null)
    username = lookup(module.cluster, "username", null)
    password = lookup(module.cluster, "password", null)
    cluster_ca_certificate = lookup(module.cluster, "cluster_ca_certificate", null)
    token = lookup(module.cluster, "token", null)
    client_certificate = lookup(module.cluster, "client_certificate", null)
    client_key = lookup(module.cluster, "client_key", null)
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}