data "aws_caller_identity" "current" {}

resource "null_resource" "noop" {
  triggers = {
    account_id = data.aws_caller_identity.current.account_id
  }
}

output "account_id" { value = data.aws_caller_identity.current.account_id }
output "caller_arn" { value = data.aws_caller_identity.current.arn }