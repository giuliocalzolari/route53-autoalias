data "archive_file" "zip_lambda" {
  type        = "zip"
  source_file = "${path.module}/src/main.py"
  output_path = "${path.module}/lambda_main.zip"
}

data "null_data_source" "lambda_file" {
  inputs {
    filename = "${substr("${path.module}/lambda_main.zip", length(path.cwd) + 1, -1)}"

  }
}

resource "aws_lambda_function" "lambda_fun" {
  filename      = "${data.null_data_source.lambda_file.outputs.filename}"
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
