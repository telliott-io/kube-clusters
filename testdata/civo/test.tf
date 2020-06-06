module "civo" {
    source = "../../civo"
    cluster_name = "test-cluster"
}

provider "civo" {
  token = var.civo_api_key
}

variable "civo_api_key" {
}

provider "kubernetes" {
    load_config_file = false
    host     = module.civo.kubernetes.host
    username = module.civo.kubernetes.username
    password = module.civo.kubernetes.password
    cluster_ca_certificate = module.civo.kubernetes.cluster_ca_certificate
    token = module.civo.kubernetes.token
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