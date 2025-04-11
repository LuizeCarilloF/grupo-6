provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "g6_vpc" {
  cidr_block = "10.6.0.0/16"
  tags = {
    Name = "g6-vpc"
  }
}

resource "aws_subnet" "g6_subnet_publica" {
  vpc_id                  = aws_vpc.g6_vpc.id
  cidr_block              = "10.6.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "g6-subnet-publica"
  }
}

resource "aws_subnet" "g6_subnet_privada" {
  vpc_id            = aws_vpc.g6_vpc.id
  cidr_block        = "10.6.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "g6-subnet-privada"
  }
}

resource "aws_internet_gateway" "g6_igw" {
  vpc_id = aws_vpc.g6_vpc.id
  tags = {
    Name = "g6-igw"
  }
}

resource "aws_route_table" "g6_route_table" {
  vpc_id = aws_vpc.g6_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.g6_igw.id
  }
  tags = {
    Name = "g6-rtb"
  }
}

resource "aws_route_table_association" "g6_assoc" {
  subnet_id      = aws_subnet.g6_subnet_publica.id
  route_table_id = aws_route_table.g6_route_table.id
}

resource "aws_eip" "g6_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "g6_nat" {
  allocation_id = aws_eip.g6_eip.id
  subnet_id     = aws_subnet.g6_subnet_publica.id

  tags = {
    Name = "g6-nat-gateway"
  }
}

resource "aws_route_table" "g6_private_rtb" {
  vpc_id = aws_vpc.g6_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.g6_nat.id
  }

  tags = {
    Name = "g6-private-rtb"
  }
}

resource "aws_route_table_association" "g6_private_rtb_assoc" {
  subnet_id      = aws_subnet.g6_subnet_privada.id
  route_table_id = aws_route_table.g6_private_rtb.id
}

resource "aws_security_group" "g6_sg_ec2" {
  name        = "g6-sg-ec2"
  description = "Acesso SSH e HTTP"
  vpc_id      = aws_vpc.g6_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "g6_ec2" {
  ami                         = "ami-0e001c9271cf7f3b9"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.g6_subnet_publica.id
  vpc_security_group_ids      = [aws_security_group.g6_sg_ec2.id]
  associate_public_ip_address = true
  key_name                    = "key-publica-g6"

  tags = {
    Name = "g6-ec2"
  }
}

resource "aws_instance" "g6_ec2_privada" {
  ami                         = "ami-0e001c9271cf7f3b9"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.g6_subnet_privada.id
  vpc_security_group_ids      = [aws_security_group.g6_sg_ec2.id]
  associate_public_ip_address = false
  key_name                    = "key-privada-g6"

  tags = {
    Name = "g6-ec2-privada"
  }
}

resource "random_id" "g6_bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "g6_bucket" {
  bucket = "g6-bucket-${random_id.g6_bucket_id.hex}"
  tags = {
    Name = "g6-bucket"
  }
}
