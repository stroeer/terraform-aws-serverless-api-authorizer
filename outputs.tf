output "lambda" {
  description = "The lambda function resource that has been created."
  value       = aws_lambda_function.authorizer
}

output "lambda_role" {
  description = "The attached role of the created lambda function."
  value       = aws_iam_role.authorizer
}