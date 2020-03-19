data "archive_file" "zip" {
    type = "zip"
    source_dir = "./app/"
    output_path = "./lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "lambda.zip"
  function_name = "test"
  role          = aws_iam_role.lambda_assume_role.arn
  handler       = "lambda.lambda_handler"
  runtime       = "python3.6"
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_iam_role" "lambda_assume_role" {
  name = "assume-role-lambda-test"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

data "aws_iam_policy" "ManagedPolicy" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}