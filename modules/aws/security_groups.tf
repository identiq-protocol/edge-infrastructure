resource "aws_security_group" "pinky_ingress" {
  name        = "${var.vpc_name}-pinky-ingress"
  description = "Allow inbound traffic from member to idq API"
  vpc_id      = local.eks_vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "${var.vpc_name}-pinky-ingress"
  }

}
