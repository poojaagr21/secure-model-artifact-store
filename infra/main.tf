# Specify the AWS provider and region

provider "aws" {
  region = "us-east-1"   
}

# Create an S3 bucket for storing model artifacts
resource "aws_s3_bucket" "model_artifact_bucket" {
  bucket = "secure-model-artifact-store-pooja123"

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

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-s3-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name = "lambda-s3-access-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::secure-model-artifact-store-pooja123/*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_s3_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
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
