//--------------------------------------------------------------------
// Variables
variable "k8s_organization" {
    type="string"
    description="Terraform Enterprise k8s Organization"
}

variable "k8s_workspace" {
    type="string"
    description="Terraform Enterprise k8s Workspace"
}

data "terraform_remote_state" "k8s" {
    backend = "atlas"
    config {
        name = "${var.k8s_organization}/${var.k8s_workspace}"
    }
}

//--------------------------------------------------------------------
// Modules
module "spring_transit" {
  source  = "app.terraform.io/Darnold-WalMart_Demo/spring-transit/k8s"
  version = "1.0.0"

  k8s_endpoint = "${data.terraform_remote_state.k8s.endpoint}"
  k8s_master_auth_client_certificate = "${base64decode(data.terraform_remote_state.k8s.client_certificate)}"
  k8s_master_auth_client_key = "${base64decode(data.terraform_remote_state.k8s.client_key)}"
  k8s_master_auth_cluster_ca_certificate = "${base64decode(data.terraform_remote_state.k8s.cluster_ca_certificate)}" 
}
