provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
  profile = "d2si"
}

data "template_file" "lambda" {
  template = file("${path.module}/lambda.py.tpl")

  vars = {
    mybucket = var.mybucket
    transfer_role_arn = aws_iam_role.TransferSFTPS3AccessRole.arn
    UserSigninDomain = var.okta_domain
  }
}

resource "local_file" "lambda" {
  content  = data.template_file.lambda.rendered
  filename = "./app/lambda.py"
}