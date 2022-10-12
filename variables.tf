# VARIABLES
variable "sender_email" {
  type = string
  default = ""
  description = "'From' email to use when forwarding a message, defaults to recipient email in the Lambda"
}

variable "recipient_email" {
  type = string
  description = "Receiving email address for forwarded messages"
  default = ""
}
