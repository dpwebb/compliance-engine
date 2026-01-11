resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  # delete noncurrent versions after 60 days
  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 60
    }
  }

  # abort incomplete multipart uploads after 7 days
  rule {
    id     = "abort-mpu"
    status = "Enabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}