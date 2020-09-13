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

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

