resource "aws_lambda_function" "upload_model" {
  # existing code...

  reserved_concurrent_executions = 5  # Optional limit
}
