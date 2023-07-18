output "vpc_id" {
  description = "The id of the VPC"
  value = aws_vpc.my_vpc.id
}

output "public_subnets_a_id" {
  description = "The public subnets a's id"
  value = aws_subnet.public_subnet_a.id
}

output "public_subnets_b_id" {
  description = "The public subnets b's id"
  value = aws_subnet.public_subnet_b.id
}

output "private_subnets_a_id" {
  description = "The private subnets a's id "
  value = aws_subnet.private_subnet_a.id
}

output "private_subnets_b_id" {
  description = "The public subnets b's id"
  value = aws_subnet.private_subnet_b.id
}

