locals {
  authorizer_name = "${var.prefix}${var.name}${var.suffix}"
  handler = var.handler != "" ? var.handler : var.name
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

data "archive_file" "authorizer" {
  type        = "zip"
  source_file = "${var.artifact_folder}/${var.name}"
  output_path = "${var.name}.zip"
}

resource "aws_iam_role" "authorizer" {
  name               = "${local.authorizer_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
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
