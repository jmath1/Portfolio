data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/scheduler_lambda.py"
  output_path = "${path.module}/scheduler_lambda.zip"
}
