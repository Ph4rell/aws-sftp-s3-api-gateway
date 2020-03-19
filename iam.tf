###############################
# SFTP Access API Gateway Role
###############################
resource "aws_iam_role" "transfer_IdP_role" {
  name 		            = "TransferIdentityProviderRole"
  description         = "transfer role"
  assume_role_policy  = data.aws_iam_policy_document.transfer_IdP_assume_role_policy.json
}

data "aws_iam_policy_document" "transfer_IdP_assume_role_policy" {
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

resource "aws_iam_policy" "transfer_IdP_policy" {
  name    = "transfer_IdP_policy"
  policy  = data.aws_iam_policy_document.transfer_IdP_document.json
}

resource "aws_iam_role_policy_attachment" "transfer_IdP_attachment" {
  policy_arn  = aws_iam_policy.transfer_IdP_policy.arn
  role        = aws_iam_role.transfer_IdP_role.id
}

data "aws_iam_policy_document" "transfer_IdP_document" {
  version = "2012-10-17"

  statement {
    sid       = "TransferCanInvokeThisApi"
    actions   = ["execute-api:Invoke"]
    effect    = "Allow"
    resources = [
      "${aws_api_gateway_stage.stage.execution_arn}/GET/*"
    ]
  }
  statement {
    sid       = "TransferCanReadThisApi"
    actions   = ["apigateway:GET"]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
    sid       = "TransferCanVerifyReturnedUserRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = [aws_iam_role.TransferSFTPS3AccessRole.arn]
  }
}
#########################################
# SFTP Access Bucket S3 & Cloudwatch Role
#########################################
resource "aws_iam_role" "TransferSFTPS3AccessRole" {
  name 		            = "TransferSFTPS3AccessRole"
  description         = "TransferSFTPS3AccessRole"
  assume_role_policy  = data.aws_iam_policy_document.TransferSFTPS3Access_assume_role_policy.json
}

data "aws_iam_policy_document" "TransferSFTPS3Access_assume_role_policy" {
  statement {
    sid     = "AssumeRole"
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

resource "aws_iam_policy" "TransferSFTPS3Access_policy" {
  name    = "TransferSFTPS3Access_policy"
  policy  = data.aws_iam_policy_document.TransferSFTPS3Access_document.json
}

resource "aws_iam_role_policy_attachment" "TransferSFTPS3Access_attachment" {
  policy_arn  = aws_iam_policy.TransferSFTPS3Access_policy.arn
  role        = aws_iam_role.TransferSFTPS3AccessRole.id
}

data "aws_iam_policy_document" "TransferSFTPS3Access_document" {
  version = "2012-10-17"

  statement {
    sid     = "TransferSFTPS3BucketAccessPolicy"
    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObjectVersion",
      "s3:GetObjectVersion",
      "s3:GetObjectACL",
      "s3:PutObjectACL",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement {
    sid     = "ListBucketPolicy"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.bucket.arn}"
    ]
  }

  statement {
    sid     = "CloudWatchLogs"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

#############################
# API Cloudwatch Role
#############################
resource "aws_iam_role" "ApiGatewayLogsRole" {
  name 		            = "ApiGatewayLogsRole"
  description         = "ApiGatewayLogsRole"
  assume_role_policy  = data.aws_iam_policy_document.ApiGatewayLogsRole_assume_role_policy.json
}

data "aws_iam_policy_document" "ApiGatewayLogsRole_assume_role_policy" {
  version = "2012-10-17"

  statement {
    sid     = "AssumeRole"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "ApiGatewayLogsPolicy" {
  name    = "ApiGatewayLogsPolicy"
  policy  = data.aws_iam_policy_document.ApiGatewayLogsPolicy_document.json
}

resource "aws_iam_role_policy_attachment" "ApiGatewayLogs_attachment" {
  policy_arn  = aws_iam_policy.ApiGatewayLogsPolicy.arn
  role        = aws_iam_role.ApiGatewayLogsRole.id
}

data "aws_iam_policy_document" "ApiGatewayLogsPolicy_document" {
  version = "2012-10-17"

  statement {
    sid     = "CloudWatchLogs"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}