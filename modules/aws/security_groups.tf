locals {

  pinky_ingress_tags = {
    Name = "${var.vpc_name}-pinky-ingress"
  }

}
resource "aws_security_group" "pinky_ingress" {
  name        = "${var.vpc_name}-pinky-ingress"
  description = "Allow inbound traffic from member to idq API"
  vpc_id      = local.eks_vpc_id

  egress {
    description      = "Open all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.default_tags, var.tags, local.pinky_ingress_tags)

}

resource "aws_security_group_rule" "pink_ingress" {
  count             = length(var.pinky_ingress_rules)
  from_port         = var.pinky_ingress_rules[count.index].from_port
  protocol          = var.pinky_ingress_rules[count.index].protocol
  security_group_id = aws_security_group.pinky_ingress.id
  to_port           = var.pinky_ingress_rules[count.index].to_port
  cidr_blocks       = var.pinky_ingress_rules[count.index].cidr_blocks
  type              = var.pinky_ingress_rules[count.index].type
}


