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
    load_config_file = lookup(module.cluster.kubernetes, "load_config_file", false)
    config_path = lookup(module.cluster.kubernetes, "config_path", null)
    host     = lookup(module.cluster.kubernetes, "host", null)
    username = lookup(module.cluster.kubernetes, "username", null)
    password = lookup(module.cluster.kubernetes, "password", null)
    cluster_ca_certificate = lookup(module.cluster.kubernetes, "cluster_ca_certificate", null)
    token = lookup(module.cluster.kubernetes, "token", null)
    client_certificate = lookup(module.cluster.kubernetes, "client_certificate", null)
    client_key = lookup(module.cluster.kubernetes, "client_key", null)
}

module "verification" {
  source = "../verifier"
}

output "hello" {
  value = module.verification.hello
}