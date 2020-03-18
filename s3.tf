resource "aws_s3_bucket" "bucket" {
  bucket = "my-personal-bucket-test-for-sftp-tests"
  acl    = "private"
}
