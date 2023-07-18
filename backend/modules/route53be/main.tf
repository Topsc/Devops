data "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "uat" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.UAT_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.PROD_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}