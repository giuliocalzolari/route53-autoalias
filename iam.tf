data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions = [
      "ec2:DescribeInstances",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "lambda_${var.app_name}_policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.lambda_policy_doc.json}"
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Sid": ""
    }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_ec2" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "basic-exec-role" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "route53-role" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53AutoNamingFullAccess"
}
