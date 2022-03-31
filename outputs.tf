output "authorizer" {
  description = "The lambda function resource that has been created."
  value       = aws_lambda_function.authorizer
}

output "authorizer_role" {
  description = "The attached role of your authorizer lambda."
  value       = aws_iam_role.authorizer
}

output "invocator" {
  description = "The api gateway authorizer that will invoke your custom lambda authorizer."
  value       = aws_api_gateway_authorizer.invocator
}

output "invocator_role" {
  description = "The role that will be used by the api gateway when invoking your authorizer lambda."
  value       = aws_iam_role.invocator
}
