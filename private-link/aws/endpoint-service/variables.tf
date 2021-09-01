variable "acceptance_required" {
  default = true
}
variable "nlb_arn" {}
variable "allowed_principals" {
  default = ["*"]
}

variable "region" {
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Name = "Identiq Endpoint Service"
  }
}
