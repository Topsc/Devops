output "alb_sg_id" {
  description = "The alb sg id"
  value = aws_security_group.alb_sg.id
}

output "service_sg_id" {
  description = "The service sg id"
  value = aws_security_group.service_sg.id
}

