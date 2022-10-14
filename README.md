# Terraform AWS HTML Form Action ![](https://img.shields.io/github/workflow/status/TechNative-B-V/terraform-aws-html-form-action/Lint?style=plastic)

Implements a simple form handler for plain html forms. Great for static
website. Sets up Lambda and API Gateway.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

This modules creates and API Gateway POST resource and connects this to a
lambda function. When a HTML form is submitted the API Gateway forwards the
formdata to the lambda function and this sends the email.

## This module does not..

Create a SES endpoint. You should do this yourself.

## Usage

```hcl
module "form_action_example_com" {
  source         = "TechNative-B-V/terraform-aws-html-form-action/aws"

  name           = "example-com-form-action-handler"
  to_email       = "webinbox@example.com" # Make sure SES accepts this email address or complete domain
  from_email     = "no-reply@example.com" # Make sure SES accepts this email address or complete domain
  allowed_origin = "*" # You should set this to the website url when live
}

output "form_action_example_com_url_for_form" {
  description = "Use this URL in your the action attribute of your form element."
  value = module.form_action_example_com.message_post_url
}
```


## Local Python development

```
AWS_PROFILE=some-profile python lambda_src/html_form_action.py
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | 3.3.1 |
| <a name="module_resource_cors"></a> [resource\_cors](#module\_resource\_cors) | mewa/apigateway-cors/aws | 2.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.message](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.message](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_resource.message](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_lambda_permission.lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_origin"></a> [allowed\_origin](#input\_allowed\_origin) | Which origin to allow submissions from. Use * when testing | `string` | `"*"` | no |
| <a name="input_from_email"></a> [from\_email](#input\_from\_email) | Receiving email address for forwarded messages, can also be configured in html form | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use for function and api gateway | `string` | n/a | yes |
| <a name="input_to_email"></a> [to\_email](#input\_to\_email) | 'From' email to use when forwarding a message, defaults to recipient email in the Lambda, can also be configured in html form | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_message_post_url"></a> [message\_post\_url](#output\_message\_post\_url) | POST URL for message requests |
<!-- END_TF_DOCS -->
