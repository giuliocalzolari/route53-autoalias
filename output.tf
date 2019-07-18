
output "lambda_arn" {
  description = "AWS Lambda ARN"
  value       = "${aws_lambda_function.lambda_fun.arn}"
}

output "lambda_iam_role_name" {
  description = "IAM role name"
  value       = "${aws_iam_role.lambda_role.name}"
}

output "lambda_iam_role_arn" {
  description = "IAM role ARN"
  value       = "${aws_iam_role.lambda_role.arn}"
}

output "cloudwatch_event_rule_id" {
  description = "Cloudwatch rule ID"
  value       = "${aws_cloudwatch_event_rule.cw_rule_lambda.id}"
}