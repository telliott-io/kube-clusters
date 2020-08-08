resource "civo_kubernetes_cluster" "cluster1" {
    name = var.cluster_name
    num_target_nodes = 2
}

variable cluster_name {}

output kubeconfig {
  value = civo_kubernetes_cluster.cluster1.kubeconfig
}

output "kubernetes" {
  depends_on = [civo_kubernetes_cluster.cluster1]
  value = {
    load_config_file = false
    host     = civo_kubernetes_cluster.cluster1.api_endpoint
    username = yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).users[0].user.username
    password = yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).users[0].user.password
    cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).clusters[0].cluster.certificate-authority-data)
  }
  sensitive = true
}

output "dns_name" {
  depends_on = [civo_kubernetes_cluster.cluster1]
  value = civo_kubernetes_cluster.cluster1.dns_entry
}