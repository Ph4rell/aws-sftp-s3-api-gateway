# aws-sftp-s3-api-gateway

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| OktaAuthApiUri | Okta Authorization API URL (such as https://<YOUR-OKTA-ENDPOINT>/api/v1/authn) | `string` | n/a | yes |
| api\_name | Name of your API | `string` | n/a | yes |
| lambda\_name | Name of the lambda | `string` | n/a | yes |
| mybucket | Name of the bucket to create | `string` | n/a | yes |
| okta\_domain | Domain part of user’s sign-in for Okta (For example, for janedoe@amazon.com, the domain is amazon.com.) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| invoke\_url | The URL to invoke the API pointing to the stage, e.g. https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod |
| lambda\_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws\_api\_gateway\_integration's uri |
| sftp\_server\_endpoint | The endpoint of the Transfer Server (e.g. s-12345678.server.transfer.REGION.amazonaws.com) |
| sftp\_server\_id | The Server ID of the Transfer Server (e.g. s-12345678) |
| stage\_execute\_arn | The execution ARN to be used in lambda\_permission's source\_arn when allowing API Gateway to invoke a Lambda function. |