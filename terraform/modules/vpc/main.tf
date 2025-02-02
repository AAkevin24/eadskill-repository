data "aws_availability_zones" "available" {}

resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id 
}

resource "aws_vpc" "ead_skill" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ead-skill-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.ead_skill.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.ead_skill.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.ead_skill.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.ead_skill.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = "private-subnet-b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ead_skill.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ead_skill.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)

  subnet_id      = element([aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id], count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ead_skill.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)

  subnet_id      = element([aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id], count.index)
  route_table_id = aws_route_table.private.id
}
