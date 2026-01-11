data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Globally-unique bucket name using your AWS account id
resource "aws_s3_bucket" "artifacts" {
  bucket        = "ce-artifacts-${data.aws_caller_identity.current.account_id}"
  force_destroy = false
  tags = {
    Project = "compliance-engine"
    Environment = "staging"
  }
}

# S3 object ownership: disable ACLs (recommended) and enforce bucket owner
resource "aws_s3_bucket_ownership_controls" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  rule { object_ownership = "BucketOwnerEnforced" }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [aws_s3_bucket_ownership_controls.artifacts]
}

# Versioning
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration { status = "Enabled" }
}

# Default encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

# Require TLS for all requests (deny HTTP)
data "aws_iam_policy_document" "require_tls" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    principals { type = "*" identifiers = ["*"] }
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*"
    ]
    condition { test = "Bool" variable = "aws:SecureTransport" values = ["false"] }
  }
}

resource "aws_s3_bucket_policy" "require_tls" {
  bucket = aws_s3_bucket.artifacts.id
  policy = data.aws_iam_policy_document.require_tls.json
  depends_on = [
    aws_s3_bucket_public_access_block.artifacts,
    aws_s3_bucket_ownership_controls.artifacts
  ]
}

output "artifacts_bucket_name" { value = aws_s3_bucket.artifacts.bucket }
output "artifacts_bucket_arn"  { value = aws_s3_bucket.artifacts.arn }