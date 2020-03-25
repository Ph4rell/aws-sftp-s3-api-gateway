data "aws_iam_policy" "ManagedPolicy" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "template_file" "lambda" {
  template = file("${path.module}/lambda.py.tpl")

  vars = {
    mybucket = var.mybucket
    transfer_role_arn = aws_iam_role.TransferSFTPS3AccessRole.arn
    UserSigninDomain = var.okta_domain
    OktaAuthApiUri = var.OktaAuthApiUri
    user_policy = data.aws_iam_policy_document.user_document.json
  }
}

data "archive_file" "zip" {
  type          = "zip"
  source_dir    = "./app/"
  output_path   = "./lambda.zip"

  depends_on = [
    local_file.lambda
  ]  
}

data "aws_iam_policy_document" "user_document" {
  version = "2012-10-17"
  statement {
    sid     = "UserPolicy"
    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObjectVersion",
      "s3:GetObjectVersion",
      "s3:GetObjectACL",
      "s3:PutObjectACL"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.bucket.arn}/$${transfer:UserName}/*",
      "${aws_s3_bucket.bucket.arn}/$${transfer:UserName}"
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
}