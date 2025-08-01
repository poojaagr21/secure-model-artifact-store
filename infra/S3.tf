resource "aws_s3_bucket" "model_artifact_store" {
  bucket = "ml-model-artifacts-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.model_artifact_store.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup_rule" {
  bucket = aws_s3_bucket.model_artifact_store.bucket

  rule {
    id     = "retain-old-models"
    status = "Enabled"

    noncurrent_version_transition {
      days          = 30
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 365
    }
  }
}
