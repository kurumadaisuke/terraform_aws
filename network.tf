locals {
  cidr_block ={
    vpc = "10.1.0.0/16",
    public_a = "10.1.11.0/24",
    public_c = "10.1.12.0/24",
    private_a = "10.1.13.0/24",
    private_c = "10.1.14.0/24",
  }
} 
#VPC
resource "aws_vpc" "main" {
  cidr_block                       = lookup(local.cidr_block,"vpc") 
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "vpc-terraform"
    # Name = element(local.cidr_block,lookup(local.cidr_block,"vpc")[count.index] )
  }
}

#Subnet
resource "aws_subnet" "public-a" {
  availability_zone       = "ap-northeast-1a"
  vpc_id                  = aws_vpc.main.id
  cidr_block              = lookup(local.cidr_block,"public_a")
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicA-terraform"
  }
}

resource "aws_subnet" "public-c" {
  availability_zone       = "ap-northeast-1c"
  vpc_id                  = aws_vpc.main.id
  cidr_block              = lookup(local.cidr_block,"public_c")
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicC-terraform"
  }
}

resource "aws_subnet" "private-1a" {
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(local.cidr_block,"private_a")

  tags = {
    Name = "PraivateA-terraform"
  }
}
resource "aws_subnet" "private-1c" {
  availability_zone = "ap-northeast-1c"
  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(local.cidr_block,"private_c")

  tags = {
    Name = "PraivateC-terraform"
  }
}

#routetable
resource "aws_route_table" "public_routetable_terraform" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public_routetable_terraform"
  }
}

resource "aws_route_table_association" "public_routetable_1a" {
  route_table_id = aws_route_table.public_routetable_terraform.id
  subnet_id      = aws_subnet.public-a.id
}

resource "aws_route_table_association" "public_routetable_1c" {
  route_table_id = aws_route_table.public_routetable_terraform.id
  subnet_id      = aws_subnet.public-c.id
}

resource "aws_route_table" "private_routetable_terraform" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private_routetable_terraform"
  }
}

resource "aws_route_table_association" "private_routetable_1a" {
  route_table_id = aws_route_table.private_routetable_terraform.id
  subnet_id      = aws_subnet.private-1a.id
}

resource "aws_route_table_association" "private_routetable_1c" {
  route_table_id = aws_route_table.private_routetable_terraform.id
  subnet_id      = aws_subnet.private-1c.id
}

#internetGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "terraform_IGW"
  }
}

resource "aws_route" "public_IGW" {
  route_table_id         = aws_route_table.public_routetable_terraform.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}