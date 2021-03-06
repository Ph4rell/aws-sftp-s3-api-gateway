resource "aws_api_gateway_rest_api" "api" {
  name    = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

###################
# API DEPLOYMENT
##################
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
###################
# API STAGE
##################
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

  request_templates = {
    "application/json" = <<EOF
{
  "username": "$input.params('username')",
  "password": "$util.escapeJavaScript($input.params('Password')).replaceAll("\\'","'")",
  "serverId": "$input.params('serverId')"
}
EOF
}
}

#########################
#API INTEGRATION RESPONSE
#########################
resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
}

#########################
#API METHOD RESPONSE
#########################
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.config.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Model"
  }

  depends_on = [
    aws_api_gateway_model.model
  ]
}

###################
# API MODEL
##################
resource "aws_api_gateway_model" "model" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "Model"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "UserUserConfig",
  "type": "object",
  "properties": {
    "Role": {
      "type": "string"
    },
    "Policy": {
      "type": "string"
    },
    "HomeDirectory": {
      "type": "string"
    },
    "PublicKeys": {
      "type": "array",
      "items": {
        "type": "string"
      }
    }
  }
}
EOF
}