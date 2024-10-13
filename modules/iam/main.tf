resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name   = "ecsTaskExecutionPolicy"
  policy = data.aws_iam_policy_document.ecs_task_execution_policy_document.json
}

data "aws_iam_policy_document" "ecs_task_execution_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}

output "iam_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
