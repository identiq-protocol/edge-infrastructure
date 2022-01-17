variable "key_pair_name" {
  default = "identiq-edge-key-pair"
}

variable "verification_tool_disk_size" {
  default = 1024
}

variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "m5.4xlarge"
}

variable "vpc_id" {
  default = ""
}

variable "private_subnet_id" {
  default = ""
}

variable "private_only" {
  default = false
}
variable "sg_ingress_cidr_blocks" {
  default = []
}
variable "sg_ingress_my_ip" {
  default = true
}



