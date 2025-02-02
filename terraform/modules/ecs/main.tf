resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.task_definition_name}"
  retention_in_days = 30
}


resource "aws_ecs_cluster" "main" {
  name = "ead-skill-cluster"
}


resource "aws_ecs_task_definition" "app_task" {
  family                   = var.task_definition_name
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                      = 4096
  memory                   = 8192

  container_definitions = jsonencode([
    {
      name      = var.db_container_name
      image     = var.image_url_populate
      memory    = 2048
      cpu       = 1024
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "populate-container"
        }
      }
     
      environment = [
        { name = "DB_HOST", value = var.db_instance_endpoint},
        { name = "DB_USER", value = "eadskill" },
        { name = "DB_PASSWORD", value = "eadskill"}
      ]
    },

    {
      name      = var.app_container_name
      image     = var.image_url_backend
      cpu       = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
            logDriver = "awslogs"
            options = {
              awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
              awslogs-region        = "us-east-1"
              awslogs-stream-prefix = "app-container"
            }
      }

      environment = [
        { name = "DB_HOST", value = var.db_instance_endpoint},
        { name = "DB_USER", value = "eadskill" },
        { name = "DB_PASSWORD", value = "eadskill"}
      ]
      dependsOn = [
        {
          containerName = "populate-container"
          condition     = "START"
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture = "X86_64"
  }
  tags = {
    Name = var.task_definition_name
  }
}

resource "aws_ecs_service" "app_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.app_task]
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = var.vpc_id
  name        = "ecs-sg"
  description = "Security group for ECS tasks"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}