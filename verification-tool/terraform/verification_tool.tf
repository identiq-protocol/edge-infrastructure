provider "aws" {
  region = var.region
}
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cloud_pem" {
  filename        = "${path.cwd}/${var.key_pair_name}.pem"
  content         = tls_private_key.key.private_key_pem
  depends_on      = [tls_private_key.key]
  file_permission = "0400"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.key.public_key_openssh
  depends_on = [local_file.cloud_pem]
}

module "ssh-security-group" {
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  version             = "4.8.0"
  name                = "verification-tool"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = concat(var.sg_ingress_my_ip ? ["${jsondecode(data.http.my_public_ip.body).ip}/32"] : [], var.sg_ingress_cidr_blocks)
}

resource "aws_eip" "ip" {
  count = var.private_only ? 0 : 1
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name_prefix = "identiq_data_verification_tool_profile"
  role = var.iam_role_name
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.4.0"

  name = "Identiq Data Verification Tool"
  root_block_device = [{
    volume_size           = var.verification_tool_disk_size
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }]
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [module.ssh-security-group.security_group_id]
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = var.private_only ? false : true
  tags = {
    Name = "Identiq Data Verification Tool"
  }

  user_data  = file("${path.cwd}/init-verification-tool.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  depends_on = [data.aws_ami.amazon-linux-2, aws_key_pair.generated_key, module.ssh-security-group]
}
resource "aws_eip_association" "eip_assoc" {
  count         = var.private_only ? 0 : 1
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.ip[0].id
  depends_on    = [module.ec2_instance, aws_eip.ip[0]]
}

output "verification_tool" {
  value = "ssh -i ${var.key_pair_name}.pem ec2-user@${var.private_only ? module.ec2_instance.private_dns : aws_eip.ip[0].public_dns}"
}
