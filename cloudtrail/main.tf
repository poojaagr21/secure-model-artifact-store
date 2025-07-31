# Create a new S3 bucket to store CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-pooja123"

  acl    = "private"

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
    Name        = "CloudTrailLogs"
    Environment = "Dev"
    Owner       = "Pooja"
  }
}

# Create CloudWatch log group for CloudTrail logs
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/secure-model"
  retention_in_days = 14
}

# IAM role that CloudTrail assumes to write to CloudWatch
resource "aws_iam_role" "cloudtrail_logs_role" {
  name = "cloudtrail-to-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Policy for that role to write logs to CloudWatch
resource "aws_iam_role_policy" "cloudtrail_logs_policy" {
  name = "cloudtrail-to-cloudwatch-policy"
  role = aws_iam_role.cloudtrail_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ],
        Resource = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
      },
      {
        Effect = "Allow",
        Action = "logs:CreateLogGroup",
        Resource = "*"
      }
    ]
  })
}

# Create CloudTrail to monitor AWS API activity
resource "aws_cloudtrail" "main" {
  name                          = "secure-model-activity-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  is_logging                    = true

  cloud_watch_logs_group_arn  = aws_cloudwatch_log_group.cloudtrail_logs.arn
  cloud_watch_logs_role_arn   = aws_iam_role.cloudtrail_logs_role.arn
}

# Optional outputs
output "cloudtrail_log_bucket" {
  value = aws_s3_bucket.cloudtrail_logs.bucket
}

output "cloudtrail_name" {
  value = aws_cloudtrail.main.name
}
