output "message_post_url" {
  value = "${aws_api_gateway_deployment.main.invoke_url}/message"
  description = "POST URL for message requests"
}
