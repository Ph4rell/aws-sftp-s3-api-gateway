#############
# LAMBDA
#############
resource "aws_cloudwatch_log_group" "LAMBDA-log-group" {
  name = var.lambda_name
}
resource "aws_cloudwatch_log_stream" "LAMBDA-log-stream" {
  name           = "LAMBDA-log-stream"
  log_group_name = aws_cloudwatch_log_group.LAMBDA-log-group.name
}

###############
# SFTP
##############
resource "aws_cloudwatch_log_group" "SFTP-log-group" {
  name = "SFTP-Server"
}

resource "aws_cloudwatch_log_stream" "SFTP-log-stream" {
  name           = "SFTP-log-stream"
  log_group_name = aws_cloudwatch_log_group.SFTP-log-group.name
}

################
# API
################
resource "aws_cloudwatch_log_group" "API-log-group" {
  name = var.api_name
}
resource "aws_cloudwatch_log_stream" "API-log-stream" {
  name           = "API-log-stream"
  log_group_name = aws_cloudwatch_log_group.API-log-group.name
}