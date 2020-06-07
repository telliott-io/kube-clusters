
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