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
