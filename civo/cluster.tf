resource "civo_kubernetes_cluster" "cluster1" {
    name = var.cluster_name
    num_target_nodes = 2
}

variable cluster_name {}

output kubeconfig {
  value = civo_kubernetes_cluster.cluster1.kubeconfig
}

resource "time_sleep" "wait_for_cluster" {
  depends_on = [civo_kubernetes_cluster.cluster1]

  create_duration = "20s"
}

output "kubernetes" {
  depends_on = [time_sleep.wait_for_cluster]
  value = {
    load_config_file = false
    host     = civo_kubernetes_cluster.cluster1.api_endpoint
    username = yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).users[0].user.username
    password = yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).users[0].user.password
    token = null
    cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).clusters[0].cluster.certificate-authority-data)
  }
  sensitive = true
}