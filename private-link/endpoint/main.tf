resource "aws_security_group" "endpoint_sg" {
  name        = "endpoint sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.current.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.current.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "endpoint sg"
  }
}
resource "aws_vpc_endpoint" "ep" {
  service_name = var.service_name
  vpc_id = data.aws_vpc.current.id
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.endpoint_sg.id]
  depends_on = [aws_security_group.endpoint_sg]
  subnet_ids = data.aws_subnet_ids.private_subnets.ids
}