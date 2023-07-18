#create a new vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = "${var.cidr_block_number}.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}
#create 2 public subnets and 2 private subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "${var.cidr_block_number}.0.0.0/20"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.public_subnet_name}_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "${var.cidr_block_number}.0.16.0/20"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.public_subnet_name}_b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "${var.cidr_block_number}.0.128.0/20"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.private_subnet_name}_a"
  }
}


resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "${var.cidr_block_number}.0.144.0/20"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.private_subnet_name}_b"
  }
}

#create a internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.internet_gateway_name
  }
}

#Create a route table for the public subnets and add a route to the internet gateway:
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

///if the product stage need to be use
# #Create route tables for the private subnets:

resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.private_route_table_name}_a"
  }
}

resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.private_route_table_name}_b"
  }
}

resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}

#Create a NAT gateway and an elastic IP for each public subnet:

resource "aws_eip" "nat_eip_a" {
  vpc = true
  tags = {
    Name = "${var.nat_eip_name}-a"
  }
}

resource "aws_eip" "nat_eip_b" {
  vpc = true
  tags = {
    Name = "${var.nat_eip_name}-b"
  }
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "${var.nat_gateway_name}_a"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id
  tags = {
    Name = "${var.nat_gateway_name}_b"
  }
}

resource "aws_route" "private_subnet_a_route" {
  route_table_id         = aws_route_table.private_route_table_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id
}

resource "aws_route" "private_subnet_b_route" {
  route_table_id         = aws_route_table.private_route_table_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_b.id
}
