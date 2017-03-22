provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

resource "aws_iam_role" "generator_iam" {
  name = "generator_iam"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

resource "aws_lambda_function" "generator_lambda" {
  filename = "lambda/nodejs/example-nodejs-lambda/example-nodejs-lambda.zip"
  description = "Example NodeJS Lambda"
  function_name = "example_nodejs_lambda"
  role = "${aws_iam_role.generator_iam.arn}"
  handler = "example-nodejs-lambda.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("lambda/nodejs/example-nodejs-lambda/example-nodejs-lambda.zip"))}"
}