resource "aws_lb" "main" {
  name                             = var.lb_name
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb_sg.id]
  subnets                          = var.subnet_ids
  enable_deletion_protection       = false

  enable_cross_zone_load_balancing = true

  tags = {
    Name = var.lb_name
  }
  depends_on = [aws_security_group.lb_sg]
}

resource "aws_lb_target_group" "target_group" {
  name                  = var.target_group_name
  port                  = 80
  protocol              = "HTTP"
  vpc_id                = var.vpc_id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.target_group_name
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id      = var.vpc_id
  name        = "load-balancer-sg"
  description = "Security group for Load Balancer"

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