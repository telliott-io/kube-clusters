resource "civo_kubernetes_cluster" "cluster1" {
    name = "test-cluster"
    num_target_nodes = 2
}

output kubeconfig {
  value = civo_kubernetes_cluster.cluster1.kubeconfig
}

output "kubernetes" {
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