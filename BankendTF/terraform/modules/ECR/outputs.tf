output "ecr_image_url" {
  value = "${aws_ecr_repository.aws-ecr.repository_url}:latest"
}