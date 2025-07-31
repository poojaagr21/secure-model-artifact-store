#----------------------------
#  AWS Provider Configuration
#----------------------------
provider "aws" {
  region = "us-east-1"
}

#----------------------------
#  Secure S3 Bucket for ML Artifacts
#----------------------------
resource "aws_s3_bucket" "model_artifact_bucket" {
  bucket = "secure-model-artifact-store-pooja123"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "ModelArtifactBucket"
    Environment = "Dev"
    Owner       = "Pooja"
  }
}

# Block all public access (recommended security)
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.model_artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#----------------------------
#  IAM Policy for Data Scientists
#----------------------------
resource "aws_iam_policy" "data_scientist_policy" {
  name = "DataScientistModelAccess"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.model_artifact_bucket.arn}/*",
          "${aws_s3_bucket.model_artifact_bucket.arn}"
        ]
      }
    ]
  })
}

#----------------------------
#  IAM Policy for Compliance (Read-only)
#----------------------------
resource "aws_iam_policy" "compliance_readonly_policy" {
  name = "ComplianceReadOnlyModelAccess"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.model_artifact_bucket.arn}/*",
          "${aws_s3_bucket.model_artifact_bucket.arn}"
        ]
      }
    ]
  })
}

#----------------------------
#  IAM Role for Lambda Execution
#----------------------------
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

#----------------------------
#  IAM Policy for Lambda (S3 + CloudWatch Logs)
#----------------------------
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
        Resource = "${aws_s3_bucket.model_artifact_bucket.arn}/*"
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

# Attach Lambda Policy to Role
resource "aws_iam_role_policy_attachment" "attach_lambda_s3_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}

#----------------------------
#  Deploy Lambda using Terraform (need to zip the Python files manually or with a script before applying Terraform).
#----------------------------

resource "aws_lambda_function" "upload_model" {
  filename         = "${path.module}/../lambda/upload_model.zip"
  function_name    = "upload_model"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "upload_model.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/../lambda/upload_model.zip")

  environment {
    variables = jsondecode(file("${path.module}/../lambda/upload_model.json"))
  }
}

resource "aws_lambda_function" "download_model" {
  filename         = "${path.module}/../lambda/download_model.zip"
  function_name    = "download_model"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "download_model.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/../lambda/download_model.zip")

  environment {
    variables = jsondecode(file("${path.module}/../lambda/download_model.json"))
  }
}

#----------------------------
#  include the CloudTrail config as a module from the relative path ../cloudtrail.
#----------------------------
module "cloudtrail" {
  source = "../cloudtrail"
}




#----------------------------
#  Outputs for Reference
#----------------------------
output "bucket_name" {
  value = aws_s3_bucket.model_artifact_bucket.bucket
}

output "data_scientist_policy_arn" {
  value = aws_iam_policy.data_scientist_policy.arn
}

output "compliance_readonly_policy_arn" {
  value = aws_iam_policy.compliance_readonly_policy.arn
}

output "lambda_exec_role_arn" {
  value = aws_iam_role.lambda_exec_role.arn
}
