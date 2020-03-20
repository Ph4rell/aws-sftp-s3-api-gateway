resource "aws_api_gateway_rest_api" "api" {
  name    = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_cloudwatch_log_group" "API-log-group" {
  name = var.api_name
}

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_integration_response.integration_response,
  ]

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deploy.id
}

#################
# API RESOURCES
################
resource "aws_api_gateway_resource" "servers" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "servers"
}
resource "aws_api_gateway_resource" "serverid" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.servers.id
  path_part   = "{serverId}"
}
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.serverid.id
  path_part   = "users"
}
resource "aws_api_gateway_resource" "username" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{username}"
}
resource "aws_api_gateway_resource" "config" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.username.id
  path_part   = "config"
}
############
#API METHOD
###########
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.config.id
  http_method   = "GET"
  authorization = "AWS_IAM"
  request_parameters = {
    # "method.request.querystring.ServerId" = true,
    # "method.request.querystring.UserName" = true,
    "method.request.header.Password" = false
  }
}

################
#API INTEGRATION
################
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.config.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

#########################
#API INTEGRATION RESPONSE
#########################
resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
}

#########################
#API METHOD RESPONSE
#########################
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
}


