terraform {
  backend "s3" {
    bucket               = "ce-tfstate-460425809402"
    key                  = "stacks/terraform.tfstate"
    region               = "ca-central-1"
    dynamodb_table       = "ce-tf-lock-460425809402"
    encrypt              = true
    workspace_key_prefix = "env"
  }
}