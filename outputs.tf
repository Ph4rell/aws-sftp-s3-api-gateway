output "invoke_url" {
    description = "The URL to invoke the API pointing to the stage, e.g. https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod"
    value = aws_api_gateway_stage.stage.invoke_url
}

output "stage_execute_arn" {
    description = "The execution ARN to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function."
    value = aws_api_gateway_stage.stage.execution_arn
}

output "sftp_server_id" {
    description = "The Server ID of the Transfer Server (e.g. s-12345678)"
    value = aws_transfer_server.server.id
}

output "sftp_server_endpoint" {
    description = "The endpoint of the Transfer Server (e.g. s-12345678.server.transfer.REGION.amazonaws.com)"
    value = aws_transfer_server.server.endpoint
}

output "lambda_arn" {
    description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
    value = aws_lambda_function.lambda.arn
}