output certs {
  value = <<EOF

internal_domain_name = ${var.internal_domain_name != "NOT_SET" ? aws_acm_certificate.int-cert[0].domain_validation_options[0].resource_record_name : "NOT_SET"}
internal_domain_value = ${var.internal_domain_name != "NOT_SET" ? aws_acm_certificate.int-cert[0].domain_validation_options[0].resource_record_value : "NOT_SET"}
internal_certificate_arn = ${var.internal_domain_name != "NOT_SET" ? aws_acm_certificate.int-cert[0].arn : "NOT_SET"}
external_domain_name = ${var.external_domain_name != "NOT_SET" ? aws_acm_certificate.ext-cert[0].domain_validation_options[0].resource_record_name : "NOT_SET"}
external_domain_value = ${var.external_domain_name != "NOT_SET" ? aws_acm_certificate.ext-cert[0].domain_validation_options[0].resource_record_value : "NOT_SET"}
external_certificate_arn = ${var.external_domain_name != "NOT_SET" ? aws_acm_certificate.ext-cert[0].arn : "NOT_SET"}
EOF
}
output connect {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
}

output nat_ips {
  value = module.vpc.nat_public_ips
}