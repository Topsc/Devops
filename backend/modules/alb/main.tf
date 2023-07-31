//cert domain
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "prod.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "certvalidation" {
  for_each = {
    for d in aws_acm_certificate.cert.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "certvalidation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.certvalidation : r.fqdn]
}


//create alb
resource "aws_lb" "alb" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.prod_public_subnet_ids
  enable_http2       = true

  idle_timeout = 60
  ///create bucket for alb logs
  access_logs {
    bucket  = var.backend_bucket.id
    prefix  = "${var.app_name}-alb-access-logs"
    enabled = true
  }
}

resource "aws_lb_target_group" "tg_prod" {
  name        = "${var.app_name}-target-group-${var.app_environment_prod}"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.prod_vpc_id
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

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" // or another policy if needed
  certificate_arn   = aws_acm_certificate_validation.certvalidation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_prod.arn
  }
}

resource "aws_lb_listener_rule" "https_prod" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_prod.arn
  }

  condition {
    host_header {
      values = ["prod.${var.domain_name}"]
    }
  }
}