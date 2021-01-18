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