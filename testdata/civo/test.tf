module "civo" {
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
    host     = module.civo.kubernetes.host
    username = module.civo.kubernetes.username
    password = module.civo.kubernetes.password
    cluster_ca_certificate = module.civo.kubernetes.cluster_ca_certificate
    token = module.civo.kubernetes.token
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}