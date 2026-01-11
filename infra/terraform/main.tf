data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Globally-unique bucket name using your AWS account id
resource "aws_s3_bucket" "artifacts" {
  bucket        = "ce-artifacts-${data.aws_caller_identity.current.account_id}"
  force_destroy = false
  tags = {
    Project     = "compliance-engine"
    Environment = "staging"
  }
}

# Enforce bucket-owner ownership (no ACLs)
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

# Require TLS for all requests (deny HTTP) — JSON policy avoids principals syntax issues
resource "aws_s3_bucket_policy" "require_tls" {
  bucket = aws_s3_bucket.artifacts.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource  = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ],
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.artifacts,
    aws_s3_bucket_ownership_controls.artifacts
  ]
}

output "artifacts_bucket_name" { value = aws_s3_bucket.artifacts.bucket }
output "artifacts_bucket_arn"  { value = aws_s3_bucket.artifacts.arn }