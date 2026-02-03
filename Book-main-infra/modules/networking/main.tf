//modules/networking/main.tf
##################################
# VPC
##################################

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

##################################
# PUBLIC SUBNETS (ALB)
##################################

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-2"
  }
}

##################################
# APPLICATION PRIVATE SUBNETS
##################################

resource "aws_subnet" "app_private_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.app_private_subnet_1_cidr
  availability_zone = var.az_1

  tags = {
    Name = "${var.vpc_name}-app-private-1"
  }
}

resource "aws_subnet" "app_private_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.app_private_subnet_2_cidr
  availability_zone = var.az_2

  tags = {
    Name = "${var.vpc_name}-app-private-2"
  }
}

##################################
# DATABASE PRIVATE SUBNETS (FUTURE USE)
##################################

resource "aws_subnet" "db_private_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.db_private_subnet_1_cidr
  availability_zone = var.az_1

  tags = {
    Name = "${var.vpc_name}-db-private-1"
  }
}

resource "aws_subnet" "db_private_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.db_private_subnet_2_cidr
  availability_zone = var.az_2

  tags = {
    Name = "${var.vpc_name}-db-private-2"
  }
}

##################################
# INTERNET GATEWAY
##################################

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

##################################
# PUBLIC ROUTE TABLE
##################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

##################################
# NAT GATEWAY
##################################

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "ig" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [aws_internet_gateway.ig]

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

##################################
# PRIVATE ROUTE TABLE
##################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ig.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "app_private_1" {
  subnet_id      = aws_subnet.app_private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "app_private_2" {
  subnet_id      = aws_subnet.app_private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_private_1" {
  subnet_id      = aws_subnet.db_private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_private_2" {
  subnet_id      = aws_subnet.db_private_2.id
  route_table_id = aws_route_table.private.id
}
