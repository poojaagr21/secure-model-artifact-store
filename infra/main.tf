# Specify the AWS provider and region
provider "aws" {
  region = "us-east-1"   
}

# Create an S3 bucket for storing model artifacts
resource "aws_s3_bucket" "model_artifact_bucket" {
  bucket = "secure-model-artifact-store-poojaagr"

  # Enable versioning to keep track of all changes to objects
  versioning {
    enabled = true
  }

  # Enable server-side encryption (AES256)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Block all public access for security
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Optional tags for easier management
  tags = {
    Name        = "ModelArtifactBucket"
    Environment = "Dev"
    Owner       = "Pooja"
  }
}

# IAM policy for Data Scientists: can upload, download, list objects
resource "aws_iam_policy" "data_scientist_policy" {
  name = "DataScientistModelAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.model_artifact_bucket.arn}/*",  # All objects in the bucket
          "${aws_s3_bucket.model_artifact_bucket.arn}"     # The bucket itself (for ListBucket)
        ]
      }
    ]
  })
}

# IAM policy for Compliance Team: read-only access to the bucket
resource "aws_iam_policy" "compliance_readonly_policy" {
  name = "ComplianceReadOnlyModelAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.model_artifact_bucket.arn}/*",
          "${aws_s3_bucket.model_artifact_bucket.arn}"
        ]
      }
    ]
  })
}

#  Outputs to get bucket name and policies ARN
output "bucket_name" {
  value = aws_s3_bucket.model_artifact_bucket.bucket
}

output "data_scientist_policy_arn" {
  value = aws_iam_policy.data_scientist_policy.arn
}

output "compliance_readonly_policy_arn" {
  value = aws_iam_policy.compliance_readonly_policy.arn
}
