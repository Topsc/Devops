#create a new vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name =  "${var.app_name}-vpc"
    Environment = var.app_environment_uat
  }
}

# aws internet gateway 
resource "aws_internet_gateway" "techscrum-internet-gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment_uat
  }
}

# aws private sunbet
resource "aws_subnet" "techscrum-private-subnet" {
  vpc_id            =  aws_vpc.my_vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment_uat
  }
}

#  aws public subnet
resource "aws_subnet" "techscrum-public-subnet" {
  vpc_id                  =  aws_vpc.my_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment_uat
  }
}

# aws elastic ip address
resource "aws_eip" "nat_eip" {
  vpc = true
  count = length(var.public_subnets)
  
  tags = {
    Name        = "${var.app_name}-nat-eip-${count.index + 1}"
    Environment = var.app_environment_prod
  }

  depends_on = [aws_internet_gateway.techscrum-internet-gateway]
}
# aws nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.techscrum-public-subnet.*.id, count.index)
  count         = length(var.public_subnets)

  tags = {
    Name        = "${var.app_name}-nat-gateway-${count.index + 1}"
    Environment = var.app_environment_prod
  }
}
# aws route table 
resource "aws_route_table" "techscrum-public-rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment_uat
  }
}

# aws route for public subnet
resource "aws_route" "techscrum-public" {
  route_table_id         = aws_route_table.techscrum-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.techscrum-internet-gateway.id
}

# aws public route table association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.techscrum-public-subnet.*.id, count.index)
  route_table_id = aws_route_table.techscrum-public-rt.id
}

# aws route table for private subnet
resource "aws_route_table" "techscrum-private-rt" {
  vpc_id = aws_vpc.my_vpc.id
  count  = length(var.private_subnets)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }

  tags = {
    Name        = "${var.app_name}-routing-table-private-${count.index + 1}"
    Environment = var.app_environment_prod
  }
}

# aws private route table association
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.techscrum-private-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.techscrum-private-rt.*.id, count.index)
}