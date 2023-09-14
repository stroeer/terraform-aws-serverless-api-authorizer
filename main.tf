locals {
  authorizer_name = "${var.prefix}${var.name}${var.suffix}"
  handler         = var.handler != "" ? var.handler : "bootstrap"
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "authorizer" {
  name               = "${local.authorizer_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "archive_file" "authorizer" {
  type        = "zip"
  source_file = "${var.artifact_folder}/bootstrap"
  output_path = "${var.name}.zip"
}

resource "aws_lambda_function" "authorizer" {
  description      = "The authorizer lambda that will check auth before calling an api gateway resource."
  function_name    = local.authorizer_name
  runtime          = var.runtime
  memory_size      = var.memory
  filename         = data.archive_file.authorizer.output_path
  source_code_hash = data.archive_file.authorizer.output_base64sha256
  role             = aws_iam_role.authorizer.arn
  handler          = local.handler
  dynamic "environment" {
    for_each = length(var.environment_vars) > 0 ? [1] : []
    content {
      variables = var.environment_vars
    }
  }
  depends_on = [
    data.archive_file.authorizer
  ]
}

data "aws_iam_policy_document" "api_gateway_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "invocation" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.authorizer.arn]
  }
}

resource "aws_iam_role" "invocator" {
  name               = "${local.authorizer_name}-invocator-role"
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role_policy.json
}

resource "aws_iam_role_policy" "invocator" {
  name   = "${local.authorizer_name}-invocator-policies"
  role   = aws_iam_role.invocator.id
  policy = data.aws_iam_policy_document.invocation.json
}

resource "aws_api_gateway_authorizer" "invocator" {
  name                   = local.authorizer_name
  type                   = var.type
  rest_api_id            = var.api_id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.invocator.arn
}
