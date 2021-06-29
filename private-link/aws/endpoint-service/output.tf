output "service_name" {
  value = aws_vpc_endpoint_service.ep.service_name
}

output "service_dns" {
  value = aws_vpc_endpoint_service.ep.base_endpoint_dns_names
}