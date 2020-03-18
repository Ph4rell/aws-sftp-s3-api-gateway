resource "aws_iam_role" "transfer_role" {
  name 		          = "transfer-Role"
  description         = "transfer role"
  assume_role_policy  = data.aws_iam_policy_document.transfer_assume_role_policy.json
}

data "aws_iam_policy_document" "transfer_assume_role_policy" {
  statement {
    sid = "AssumeRole"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "transfer.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "transfer_policy" {
  name = "TransferCanInvokeApi"
  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.transfer_policy.arn
  role = aws_iam_role.transfer_role.id
}

data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"

  statement {
    sid = "InvokeAPI"
    actions = ["execute-api:Invoke"]
    effect = "Allow"
    resources = [
      "${aws_api_gateway_stage.stage.execution_arn}"
    ]
  }

  statement {
    sid = "TransferCanReadThisApi"
    actions = ["apigateway:GET"]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}
