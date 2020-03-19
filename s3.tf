resource "aws_s3_bucket" "bucket" {
  bucket = var.mybucket
  acl    = "private"
}
