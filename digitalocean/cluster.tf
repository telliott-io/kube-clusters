data "digitalocean_kubernetes_versions" "example" {}

resource "digitalocean_kubernetes_cluster" "primary" {
  name    = var.cluster_name
  region  = "nyc1"
  # Default to the latest version slug
  version = data.digitalocean_kubernetes_versions.example.latest_version
  tags    = ["production"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

variable cluster_name {}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [digitalocean_kubernetes_cluster.primary]

  create_duration = "20s"
}

output "kubernetes" {
  depends_on = [time_sleep.wait_for_cluster]
  value = {
    load_config_file = false
    host     = digitalocean_kubernetes_cluster.primary.endpoint
    username = null
    password = null
    token = digitalocean_kubernetes_cluster.primary.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate)
    client_certificate = null
    client_key = null
  }
  sensitive = true
}