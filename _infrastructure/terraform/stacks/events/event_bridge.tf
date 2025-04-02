
resource "aws_lambda_function" "scheduler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ec2_rds_scheduler"
  role             = aws_iam_role.lambda_role.arn
  handler          = "scheduler_lambda.lambda_handler"
  runtime          = "python3.13"
  timeout          = 30
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      EC2_INSTANCE_ID = local.ec2_instance_id
      RDS_INSTANCE_IDENTIFIER = local.rds_instance_identifier
    }
  }
}

resource "aws_cloudwatch_event_rule" "shutdown_rule" {
  name                = "ec2_rds_shutdown_schedule"
  schedule_expression = "cron(0 4 ? * * *)" # every day at 4:00 UTC (11:00 PM EST)
}

resource "aws_cloudwatch_event_rule" "startup_rule" {
  name                = "ec2_rds_startup_schedule"
  schedule_expression = "cron(30 13 ? * * *)" # every day at 13:30 UTC (8:30 AM EST)
}



resource "aws_cloudwatch_event_target" "startup_target" {
  rule      = aws_cloudwatch_event_rule.startup_rule.name
  target_id = "lambda_target_start"
  arn       = aws_lambda_function.scheduler.arn
  input     = jsonencode({ "action": "start" })
}

resource "aws_cloudwatch_event_target" "shutdown_target" {
  rule      = aws_cloudwatch_event_rule.shutdown_rule.name
  target_id = "lambda_target"
  arn       = aws_lambda_function.scheduler.arn
}


resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.shutdown_rule.arn
}


resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.startup_rule.arn
}