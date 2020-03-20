provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
  profile = "d2si"
}


resource "local_file" "lambda" {
  content  = data.template_file.lambda.rendered
  filename = "./app/lambda.py"
}