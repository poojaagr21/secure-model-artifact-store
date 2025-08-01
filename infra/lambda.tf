resource "aws_lambda_function" "upload_model" {
  function_name = "upload_model"
  handler       = "upload_model.lambda_handler"  # your Python handler function
  runtime       = "python3.9"

  # Path to the zipped Lambda deployment package
  filename      = "${path.module}/../lambda/function.zip"

  role          = aws_iam_role.lambda_exec_role.arn

  timeout       = 30      # Timeout in seconds
  memory_size   = 128     # Memory allocation in MB

  # Optional: limit concurrency to avoid throttling or overload
  reserved_concurrent_executions = 5

  # To force a new deployment when the zip changes
  source_code_hash = filebase64sha256("${path.module}/../lambda/function.zip")
}
