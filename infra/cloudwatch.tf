resource "aws_cloudwatch_log_metric_filter" "lambda_error_filter" {
  name           = "lambda-error-filter"
  log_group_name = "/aws/lambda/upload_model"
  pattern        = "?ERROR ?Error ?Exception"

  metric_transformation {
    name      = "UploadModelLambdaErrors"
    namespace = "LambdaMonitoring"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors_alarm" {
  alarm_name          = "UploadModelLambdaErrorsAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UploadModelLambdaErrors"
  namespace           = "LambdaMonitoring"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alarm when Lambda function throws errors"
  actions_enabled     = false # Set to true and attach SNS topic/email if needed
}
