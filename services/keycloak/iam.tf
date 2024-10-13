resource "aws_iam_role" "keycloak_iam_role" {
  name = "keycloak-iam-role"

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

resource "aws_iam_policy" "keycloak_iam_policy" {
  name   = "keycloak-iam-policy"
  policy = data.aws_iam_policy_document.keycloak_iam_policy_document.json
}

data "aws_iam_policy_document" "keycloak_iam_policy_document" {
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

resource "aws_iam_role_policy_attachment" "keycloak_policy_attachment" {
  policy_arn = aws_iam_policy.keycloak_iam_policy.arn
  role       = aws_iam_role.keycloak_iam_role.name
}