output "vpc_id" {
  description = "The id of the VPC"
  value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.techscrum-public-subnet.*.id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.techscrum-private-subnet.*.id
}
