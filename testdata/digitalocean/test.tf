module "digitalocean" {
    source = "../../digitalocean"
    cluster_name = "test-cluster"
}

provider "digitalocean" {
  token = var.digitalocean_token
}

variable "digitalocean_token" {
}

provider "kubernetes" {
    load_config_file = false
    host     = module.digitalocean.kubernetes.host
    username = module.digitalocean.kubernetes.username
    password = module.digitalocean.kubernetes.password
    cluster_ca_certificate = module.digitalocean.kubernetes.cluster_ca_certificate
    token = module.digitalocean.kubernetes.token
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

resource "kubernetes_config_map" "example" {
  metadata {
    name = "test-config"
    namespace = "test"
  }

  data = {
    hello = "world"
  }
}

data "kubernetes_config_map" "example" {
  depends_on = [kubernetes_config_map.example]
  metadata {
    name = "test-config"
    namespace = "test"
  }
}

output "hello" {
  value = data.kubernetes_config_map.example.data.hello
}