module "digitalocean" {
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
    load_config_file = false
    host     = module.digitalocean.kubernetes.host
    username = module.digitalocean.kubernetes.username
    password = module.digitalocean.kubernetes.password
    cluster_ca_certificate = module.digitalocean.kubernetes.cluster_ca_certificate
    token = module.digitalocean.kubernetes.token
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}