output "connect" {
  value = "export KUBECONFIG=${path.cwd}/kubeconfig"
}

data "template_file" "kubeconfig" {
  template = file("${path.cwd}/kubeconfig.tpl")

  vars = {
    cluster_name    = "edge-cluster"
    endpoint        = module.aks.admin_host
    cluster_ca      = module.aks.admin_cluster_ca_certificate
    client_cert     = module.aks.admin_client_certificate
    client_cert_key = module.aks.admin_client_key
    user_name = module.aks.admin_username
    user_password = module.aks.admin_password
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "${path.cwd}/kubeconfig"
  file_permission = "0400"
}
