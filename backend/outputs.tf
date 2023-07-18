
output "repository_url" {
  description = "ECR repository URL"
  value       = module.ecr_repository.repository_url
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value = module.alb.alb_dns_name
}

output "UAT_domain_name" {
  description = "The domain name of UAT"
  value       = var.UAT_domain_name
}

output "PROD_domain_name" {
  description = "The domain name of PROD"
  value       = var.PROD_domain_name
}