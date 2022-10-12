#resource "aws_ses_email_identity" "recipient2" {
#  email = var.recipient_email
#}
#
#resource "aws_ses_email_identity" "sender2" {
#  count = var.sender_email != "" ? 1 : 0
#  email = var.sender_email
#}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  version = "3.3.1"

  function_name = "html_form_action"
  description   = "Sends mails at HTML Form submits"
  handler       = "html_form_action.lambda_handler"
  runtime       = "python3.9"

  #source_path = format("%s/lambda-src",abspath(path.module))
  #source_path = "${path.module}/lambda_src"
  source_path = [
    format("%s/lambda_src", abspath(path.module)),
    {
      #pip_requirements = format("%s/lambda-src/requirements.txt", abspath(path.module))
    }
  ]

  publish = true
  timeout = 15

  #  environment_variables = {
  #   LAMBDA_CONF = var.configured_accounts_json
  #  }

  attach_policy_json = true
  #policy_json = data.aws_iam_policy_document.lambda_extra_permissions.json
  policy_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "*"
    }
  ]
}
EOF

}

#data "aws_iam_policy_document" "lambda_extra_permissions" {
#  statement {
#    actions   = ["ses:SendEmail"]
#    resources = ["*"]
#  }
#}
#
#resource "aws_iam_policy" "send" {
#  name = "SES_Send_Email2"
#
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Action": "ses:SendEmail",
#      "Resource": "*"
#    }
#  ]
#}
#EOF
#
#}
#

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "html_form_action"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_api_gateway_rest_api" "main" {
  name = "html_form_action"
}

resource "aws_api_gateway_resource" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id = aws_api_gateway_rest_api.main.root_resource_id
  path_part = "message"
}

resource "aws_api_gateway_method" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = "POST"
  authorization = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "message" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.message.id
  http_method = "POST"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = module.lambda_function.lambda_function_invoke_arn
  depends_on = [aws_api_gateway_method.message]
}

resource "aws_api_gateway_deployment" "main" {
  stage_name = "main"
  rest_api_id = aws_api_gateway_rest_api.main.id
  depends_on = [
    aws_api_gateway_integration.message,
  ]
}

module "resource_cors" {
  source  = "mewa/apigateway-cors/aws"
  version = "2.0.0"

  api      =  aws_api_gateway_rest_api.main.id
  resource =  aws_api_gateway_resource.message.id
  methods = ["POST"]

  origin = "*"
}
