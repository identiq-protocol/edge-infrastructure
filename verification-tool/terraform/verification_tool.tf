provider "aws" {
  region = var.region
}
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cloud_pem" {
  filename = "${path.cwd}/${var.key_pair_name}.pem"
  content = tls_private_key.key.private_key_pem
  depends_on = [tls_private_key.key]
  file_permission = "0400"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.key.public_key_openssh
  depends_on = [local_file.cloud_pem]
}

resource "aws_security_group" "server-sg" {
  name_prefix = "verification-tool"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_eip" "ip" {
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.4.0"

  name = "Identiq Data Verification Tool"
  root_block_device =  [{
    volume_size = var.verification_tool_disk_size
    volume_type = "gp2"
    encrypted = true
    delete_on_termination = true
  }]
  ami                    =  data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  key_name               =  aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.server-sg.id]
  subnet_id              = var.private_subnet_id
  associate_public_ip_address = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  user_data = file("${path.cwd}/init-verification-tool.sh")
  depends_on = [data.aws_ami.amazon-linux-2, aws_key_pair.generated_key, aws_security_group.server-sg]
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.ip.id
  depends_on = [module.ec2_instance ,aws_eip.ip]
}

output verification_tool {
  value = "ssh -i ${var.key_pair_name}.pem ec2-user@${aws_eip.ip.public_dns}"
}
