module "cluster" {
    source = "../../civo"
    cluster_name = var.cluster_name
}

provider "civo" {
  token = var.civo_api_key
}

variable "civo_api_key" {
}

variable "cluster_name" {
}

provider "kubernetes" {
    load_config_file = false
    host     = module.cluster.kubernetes.host
    username = module.cluster.kubernetes.username
    password = module.cluster.kubernetes.password
    cluster_ca_certificate = module.cluster.kubernetes.cluster_ca_certificate
    token = module.cluster.kubernetes.token
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}