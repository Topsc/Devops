# creating A record for domain:
resource "aws_route53_record" "websiteurl" {
  name    = var.domain_name
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cf_dist.domain_name
    zone_id                = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = true
  }
}



//http healthcheck
resource "aws_route53_health_check" "health_check_http" {
  provider          = aws.us-east-1
  fqdn              = var.domain_name
  port              = 80
  type              = "HTTP"
  request_interval  = 30
  failure_threshold = 3
  tags = {
    Name = var.http_health_check_name
  }
}



#https healthcheck
resource "aws_route53_health_check" "health_check_https" {
  provider          = aws.us-east-1
  fqdn              = var.domain_name
  port              = 443
  type              = "HTTPS"
  request_interval  = 30
  failure_threshold = 3
  tags = {
    Name = var.https_health_check_name
  }
}


