module "form_action_example_com" {
  source         = "TechNative-B-V/html-form-action/aws"

  name           = "example-com-form-action-handler"
  to_email       = "webinbox@example.com" # Make sure SES accepts this email address or complete domain
  from_email     = "no-reply@example.com" # Make sure SES accepts this email address or complete domain
  allowed_origin = "*" # You should set this to the website url when live
}
