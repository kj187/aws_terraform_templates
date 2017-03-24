provider "aws" {}

resource "aws_iam_role" "lambda_nodejs_example_iam_role" {
  name               = "lambda_nodejs_example_iam_role"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

resource "aws_iam_role_policy" "lambda_nodejs_example_iam_role_policy" {
  name        = "lambda_nodejs_example_iam_role_policy"
  role        = "${aws_iam_role.lambda_nodejs_example_iam_role.id}"
  policy      = "${file("policies/lambda-policy.json")}"
}

resource "aws_s3_bucket" "lambda_nodejs_example_bucket" {
  bucket        = "lambda-nodejs-example-bucket"
  acl           = "private"
  force_destroy = true
}

resource "aws_lambda_function" "lambda_nodejs_example" {
  filename         = "lambda/nodejs/example-nodejs-lambda/example-nodejs-lambda.zip"
  description      = "Example NodeJS Lambda"
  function_name    = "example_nodejs_lambda"
  role             = "${aws_iam_role.lambda_nodejs_example_iam_role.arn}"
  handler          = "example-nodejs-lambda.handler"
  runtime          = "nodejs4.3"
  source_code_hash = "${base64sha256(file("lambda/nodejs/example-nodejs-lambda/example-nodejs-lambda.zip"))}"
}
