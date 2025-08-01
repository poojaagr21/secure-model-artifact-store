resource "aws_lambda_function" "upload_model" {
  function_name = "upload_model"
  handler       = "upload_model.lambda_handler"
  runtime       = "python3.9"

  filename      = "${path.module}/../lambda/function.zip" 

  role          = aws_iam_role.lambda_exec_role.arn

  timeout       = 30
  memory_size   = 128

  reserved_concurrent_executions = 5

  source_code_hash = filebase64sha256("${path.module}/../lambda/function.zip")
}

resource "aws_lambda_function" "download_model" {
  function_name = "download_model"
  handler       = "download_model.lambda_handler"
  runtime       = "python3.9"

  filename      = "${path.module}/../lambda/function.zip"

  role          = aws_iam_role.lambda_exec_role.arn

  timeout       = 30
  memory_size   = 128

  reserved_concurrent_executions = 5

  source_code_hash = filebase64sha256("${path.module}/../lambda/function.zip")
}
