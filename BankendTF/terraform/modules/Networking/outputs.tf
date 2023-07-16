output "vpc-id" {
  value = aws_vpc.techscrumbackend-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}