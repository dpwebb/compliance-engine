terraform {
  backend "s3" {
    bucket         = "ce-tfstate-460425809402"
    key            = "stacks/${var.environment}/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "ce-tf-lock-460425809402"
    encrypt        = true
  }
}