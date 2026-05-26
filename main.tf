module "github_repository" {
  source                   = "github.com/den-vasyliev/tf-github-repository"
  github_owner             = var.GITHUB_OWNER
  github_token             = var.GITHUB_TOKEN
  repository_name          = var.FLUX_GITHUB_REPO
  public_key_openssh       = module.tls_private_key.public_key_openssh
  public_key_openssh_title = "flux0"
}

module "gke_cluster" {
  source         = "github.com/den-vasyliev/tf-google-gke-cluster"
  GOOGLE_REGION  = var.GOOGLE_REGION
  GOOGLE_PROJECT = var.GOOGLE_PROJECT
  GKE_NUM_NODES  = 2
  GKE_MACHINE_TYPE = "e2-medium"
}

module "tls_private_key" {
  source = "github.com/den-vasyliev/tf-hashicorp-tls-keys"
}

module "gke_auth" {
  depends_on = [
    module.gke_cluster
  ]
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version              = ">= 24.0.0"
  project_id           = var.GOOGLE_PROJECT
  cluster_name         = module.gke_cluster.name
  location             = var.GOOGLE_REGION
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
}

output "kubeconfig" {
  value = "${path.module}/kubeconfig"
}


module "flux_bootstrap" {
  source            = "github.com/den-vasyliev/tf-fluxcd-flux-bootstrap"
  github_repository = "${var.GITHUB_OWNER}/${var.FLUX_GITHUB_REPO}"
  github_token      = var.GITHUB_TOKEN
  private_key       = module.tls_private_key.private_key_pem
  config_path = module.gke_cluster.kubeconfig
###  config_path = local_file.kubeconfig.filename
}

