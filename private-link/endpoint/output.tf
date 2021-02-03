output "dns" {
  value = aws_vpc_endpoint.ep.dns_entry[0]["dns_name"]
}