output "OPENSEARCH_URL" {
  description = "OPENSEARCH_URL"
  value       = module.opensearch_cluster.OPENSEARCH_URL
}

output "role_arn" {
  description = "arn of the lambda role"
  value       = module.lambda_role_module.role_arn
}