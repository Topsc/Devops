
# data source to fetch hosted zone info from domain name:
data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}





# creating A record for domain:
resource "aws_route53_record" "websiteurl" {
  name    = var.domain_name
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "A"
  alias {
    name                   = var.cloudfront.domain_name
    zone_id                = var.cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
}


