data "aws_iam_policy" "ManagedPolicy" {
    arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}