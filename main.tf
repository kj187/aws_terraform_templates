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
resource "aws_s3_bucket" "lambda_nodejs_example_bucketresized" {
  bucket        = "lambda-nodejs-example-bucketresized"
  acl           = "private"
  force_destroy = true
}

resource "aws_lambda_permission" "lambda_nodejs_example_permissions" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_nodejs_example.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.lambda_nodejs_example_bucket.arn}"
}

resource "aws_lambda_function" "lambda_nodejs_example" {
  filename         = "lambda/nodejs/example-nodejs-lambda/example-nodejs-lambda.zip"
  description      = "Example NodeJS Lambda"
  function_name    = "example_nodejs_lambda"
  role             = "${aws_iam_role.lambda_nodejs_example_iam_role.arn}"
  handler          = "example-nodejs-lambda.handler"
  runtime          = "nodejs6.10"
  source_code_hash = "${base64sha256(file("lambda/nodejs/example-nodejs-lambda/example-nodejs-lambda.zip"))}"
  timeout          = "60"
}

resource "aws_s3_bucket_notification" "lambda_nodejs_example_bucket_notification" {
  bucket = "${aws_s3_bucket.lambda_nodejs_example_bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lambda_nodejs_example.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}
