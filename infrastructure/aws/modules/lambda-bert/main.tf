resource "aws_iam_role" "lambda_exec" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.name
  role             = aws_iam_role.lambda_exec.arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  filename         = var.zip_path
  source_code_hash = filebase64sha256(var.zip_path)
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn  = var.sqs_arn
  function_name     = aws_lambda_function.lambda.arn
  batch_size        = 1
}

resource "aws_iam_role_policy" "sqs_poll" {
  name = "${var.name}-sqs-poll"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = var.sqs_arn
      }
    ]
  })
}
