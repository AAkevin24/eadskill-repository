data "aws_caller_identity" "current" {}

data "aws_iam_policy" "ecs_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role_policy.json
}

resource "aws_iam_policy" "secrets_manager_access" {
  name        = "secrets-manager-access"
  description = "Allows ECS tasks to access secrets in Secrets Manager"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue"
        Effect   = "Allow"
        Resource = var.secret_arn
      }
    ]
  })
}

data "aws_iam_policy_document" "ecs_task_permissions_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect  = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task_permissions_policy" {
  name        = "ecs_task_permissions_policy"
  description = "Política de permissões para o ECS task role"
  policy      = data.aws_iam_policy_document.ecs_task_permissions_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution_secrets_manager_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_permissions_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_secrets_manager_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}

resource "aws_iam_role_policy_attachment" "ecs_cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.ecs_execution_role.name
}