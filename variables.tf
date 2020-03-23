variable "mybucket" {
    description = "Name of the bucket to create"
    type = string
}

variable "lambda_name" {
    description = "Name of the lambda"
    type = string
}

variable "api_name" {
    description = "Name of your API"
    type = string
}

variable "okta_domain" {
    description = "Domain part of user’s sign-in for Okta (For example, for janedoe@amazon.com, the domain is amazon.com.)"
    type = string
}
variable "OktaAuthApiUri" {
    description = "Okta Authorization API URL (such as https://<YOUR-OKTA-ENDPOINT>/api/v1/authn)"
    type = string
}