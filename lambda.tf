locals {
  lambda_filename = "${substr("${path.module}/.lambda_main_payload.zip", length(path.cwd) + 1, -1)}"
}
resource "aws_lambda_function" "lambda_fun" {
  filename         = "${local.lambda_filename}"
  function_name    = "${var.app_name}"
  description      = "${var.app_name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "main.lambda_handler"
  source_code_hash = "${base64sha256(file(local.lambda_filename))}"
  runtime          = "python3.6"
  timeout          = 180
}

resource "aws_lambda_permission" "allow_execution_from_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_fun.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.cw_rule.arn}"
}
