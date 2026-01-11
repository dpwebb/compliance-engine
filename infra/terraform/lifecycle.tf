resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"
    filter {} # apply to all objects
    noncurrent_version_expiration { noncurrent_days = 60 }
  }

  rule {
    id     = "abort-mpu"
    status = "Enabled"
    filter {} # apply to all objects
    abort_incomplete_multipart_upload { days_after_initiation = 7 }
  }
}