module "form_action_example_com" {
  source         = "TechNative-B-V/terraform-aws-html-form-action/aws"

  name           = "example-com-form-action-handler"
  allowed_origin = "*" # You should set this to the website url when live
}

