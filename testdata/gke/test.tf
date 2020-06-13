module "cluster" {
    source = "../../gke"
    cluster_name = var.cluster_name
}

provider "google" {
  credentials = base64decode(var.gcloud_credentials_base64)
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

variable "gcloud_credentials_base64" {}

variable "cluster_name" {
}

provider "kubernetes" {
    load_config_file = false
    host     = module.cluster.kubernetes.host
    username = module.cluster.kubernetes.username
    password = module.cluster.kubernetes.password
    cluster_ca_certificate = module.cluster.kubernetes.cluster_ca_certificate
    token = module.cluster.kubernetes.token
    client_certificate = module.cluster.kubernetes.client_certificate
    client_key = module.cluster.kubernetes.client_key
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}