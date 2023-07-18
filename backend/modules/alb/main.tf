resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnets_a_id, var.public_subnets_b_id]
  enable_http2       = true

  idle_timeout = 60
  ///create bucket for alb logs
  access_logs {
    bucket  = "techscrum-backend-bucket"
    prefix  = "lb-access-logs"
    enabled = true
  }
}

///create the Target Group:
resource "aws_lb_target_group" "tg_uat" {
  name        = var.target_group_name
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 200
    path                = var.health_check_path
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "tg_prod" {
  name        = "${var.target_group_name}-prod"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = 200
    path                = var.health_check_path
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

///ALB-listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_uat.arn
  }
}

resource "aws_lb_listener_rule" "uat" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_uat.arn
  }

  condition {
    host_header {
      values = [var.UAT_domain_name]
    }
  }
}

resource "aws_lb_listener_rule" "prod" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_prod.arn
  }

  condition {
    host_header {
      values = [var.PROD_domain_name]
    }
  }
}