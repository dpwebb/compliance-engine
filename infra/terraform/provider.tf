variable "aws_region" {
  type    = string
  default = "ca-central-1"
}

provider "aws" {
  region = var.aws_region
}