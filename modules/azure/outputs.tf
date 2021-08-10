output "connect" {
  value = "export KUBECONFIG=${path.cwd}/kubeconfig"
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig.tpl")

  vars = {
    cluster_name    = var.aks_cluster_name
    endpoint        = module.aks.admin_host
    cluster_ca      = module.aks.admin_cluster_ca_certificate
    client_cert     = module.aks.admin_client_certificate
    client_cert_key = module.aks.admin_client_key
    user_name       = module.aks.admin_username
    user_password   = module.aks.admin_password
  }
}

resource "local_file" "kubeconfig" {
  content         = data.template_file.kubeconfig.rendered
  filename        = "${path.cwd}/kubeconfig"
  file_permission = "0400"
}

output "nat_ip" {
  value = azurerm_public_ip_prefix.nat_ip.ip_prefix
}
