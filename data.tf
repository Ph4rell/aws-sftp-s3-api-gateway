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