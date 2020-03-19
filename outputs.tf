output "invoke_url" {
    value = aws_api_gateway_stage.stage.invoke_url
}

output "stage_execute_arn" {
    value = aws_api_gateway_stage.stage.execution_arn
}

output "sftp_server_id" {
    value = aws_transfer_server.server.id
}