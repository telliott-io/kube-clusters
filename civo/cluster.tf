resource "civo_kubernetes_cluster" "cluster1" {
    name = var.cluster_name
    num_target_nodes = 2

    # Once provisioned, wait until the cluster can be accessed with the API
    provisioner "local-exec" {
    command = "${path.module}/waitforcluster.sh"

    environment = {
      HOST = civo_kubernetes_cluster.cluster1.api_endpoint
      USER = yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).users[0].user.username
      PASSWORD = yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).users[0].user.password
    }
  }
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
    token = null
    cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.cluster1.kubeconfig).clusters[0].cluster.certificate-authority-data)
  }
  sensitive = true
}