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
    sid = "TransferSFTPS3BucketAccessPolicy"
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
    sid = "ListBucketPolicy"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.bucket.arn}"
    ]
  }
}
