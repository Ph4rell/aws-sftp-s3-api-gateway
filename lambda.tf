resource "aws_lambda_function" "lambda" {
  filename          = "lambda.zip"
  function_name     = var.lambda_name
  role              = aws_iam_role.lambda_role.arn
  handler           = "lambda.lambda_handler"
  runtime           = "python3.6"
  source_code_hash  = filebase64sha256("lambda.zip")
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.api.execution_arn
}

resource "aws_iam_role" "lambda_role" {
  name 		            = "LambdRole"
  description         = "Lambda role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    sid = "AssumeRole"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ManagedPolicy_attachment" {
  role        = aws_iam_role.lambda_role.id
  policy_arn  = data.aws_iam_policy.ManagedPolicy.arn
}