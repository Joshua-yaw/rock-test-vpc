#Creating AWS Networking For a Project

resource "aws_vpc" "Rock_test-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Rock_test-vpc"
  }
}

#Creating Public Subnets

resource "aws_subnet" "Rock-test-pub-subnet1" {
  vpc_id            = aws_vpc.Rock_test-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Rock-test-pub-subnet1"
  }
}
resource "aws_subnet" "Rock-test-pub-subnet2" {
  vpc_id            = aws_vpc.Rock_test-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Rock-test-pub-subnet2"
  }
}

#Creating Private Subnets

resource "aws_subnet" "Rock-test-priv-subnet1" {
  vpc_id            = aws_vpc.Rock_test-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "Rock-test-priv-subnet1"
  }
}
resource "aws_subnet" "Rock-test-priv-subnet2" {
  vpc_id            = aws_vpc.Rock_test-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Rock-test-priv-subnet2"
  }
}

#Public Route Table
resource "aws_route_table" "Rock-test-pub-route1" {
  vpc_id = aws_vpc.Rock_test-vpc.id



  tags = {
    Name = "Rock-test-pub-route1"
  }
}

#Private Route Table
resource "aws_route_table" "Rock-test-priv-route1" {
  vpc_id = aws_vpc.Rock_test-vpc.id



  tags = {
    Name = "Rock-test-priv-route1"
  }
}

#Associate Public Subnet with the Public Route Tables
resource "aws_route_table_association" "Rock-test-pub-association1" {
  subnet_id      = aws_subnet.Rock-test-pub-subnet1.id
  route_table_id = aws_route_table.Rock-test-pub-route1.id
}

resource "aws_route_table_association" "Rock-test-pub-association2" {
  subnet_id      = aws_subnet.Rock-test-pub-subnet2.id
  route_table_id = aws_route_table.Rock-test-pub-route1.id
}

#Associate Private Subnet with the Private Route Tables
resource "aws_route_table_association" "Rock-test-priv-association1" {
  subnet_id      = aws_subnet.Rock-test-priv-subnet1.id
  route_table_id = aws_route_table.Rock-test-priv-route1.id
}
resource "aws_route_table_association" "Rock-test-priv-association2" {
  subnet_id      = aws_subnet.Rock-test-priv-subnet2.id
  route_table_id = aws_route_table.Rock-test-priv-route1.id
}

#Internet Gateway
resource "aws_internet_gateway" "Rock-test-IGW" {
  vpc_id = aws_vpc.Rock_test-vpc.id

  tags = {
    Name = "Rock-test-IGW"
  }
}

# Associating Internet Gateway to the Public Route Table

resource "aws_route" "Rock-IGW-attachment" {
  route_table_id            = aws_route_table.Rock-test-priv-route1.id
  gateway_id = aws_internet_gateway.Rock-test-IGW.id
  destination_cidr_block    = "0.0.0.0/0"

}