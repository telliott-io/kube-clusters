terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.2"
    }
  }
}

resource "kubernetes_namespace" "test" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_config_map" "example" {
  depends_on = [kubernetes_namespace.test]
  metadata {
    name = "test-config"
    namespace = var.namespace
  }

  data = {
    hello = "world"
  }
}

data "kubernetes_config_map" "example" {
  depends_on = [kubernetes_config_map.example]
  metadata {
    name = "test-config"
    namespace = var.namespace
  }
}

output "hello" {
  value = data.kubernetes_config_map.example.data.hello
}

variable namespace {
  default = "test"
}