output "connect" {
  value = "export KUBECONFIG=${path.cwd}/kubeconfig"
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig.tpl")

  vars = {
    cluster_name    = var.aks_cluster_name
    endpoint        = module.aks.host
    cluster_ca      = module.aks.cluster_ca_certificate
    client_cert     = module.aks.client_certificate
    client_cert_key = module.aks.client_key
    user_name       = module.aks.username
    user_password   = module.aks.password
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
