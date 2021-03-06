resource "aws_transfer_server" "server" {
  identity_provider_type  = "API_GATEWAY"
  endpoint_type           = "PUBLIC"
  invocation_role         = aws_iam_role.transfer_IdP_role.arn
  url                     = aws_api_gateway_stage.stage.invoke_url
  logging_role            = aws_iam_role.SFTPLogsRole.arn

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}
