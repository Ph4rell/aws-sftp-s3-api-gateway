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