output "backend_bucket" {
  description = "backend bucket"
  value       = aws_s3_bucket.backend_bucket
}

output "s3_object" {
  description = "S3 Object"
  value       = aws_s3_bucket_object.object
}