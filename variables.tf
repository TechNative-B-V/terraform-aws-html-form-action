variable "name" {
  type = string
  description = "Name to use for function and api gateway"
}

variable "allowed_origin" {
  type = string
  description = "Which origin to allow submissions from. Use * when testing"
  default = "*"
}

variable "to_email" {
  type = string
  description = "'From' email to use when forwarding a message, defaults to recipient email in the Lambda, can also be configured in html form"
  default = ""
}

variable "from_email" {
  type = string
  description = "Receiving email address for forwarded messages, can also be configured in html form"
  default = ""
}
