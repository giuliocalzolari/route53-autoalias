

resource "aws_lambda_function" "lambda_fun" {
  filename      = "${path.module}/es-cleanup.zip"
  function_name = "${var.app_name}"
  description   = "${var.app_name}"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "main.lambda_handler"
  runtime       = "python3.6"
  timeout       = 180
}

resource "aws_lambda_permission" "allow_execution_from_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_fun.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.cw_rule.arn}"
}
