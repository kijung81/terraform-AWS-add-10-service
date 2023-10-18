resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "pub_sbn_a" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.pub_sbn_a
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-pub_sbn_a"
  }
}

resource "aws_subnet" "pub_sbn_b" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.pub_sbn_b
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-pub_sbn_b"
  }  
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "${var.prefix}-intgw"
  }
}

resource "aws_route_table" "rt_igw" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.prefix}-rt-igw"
  }  
}

resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_sbn_a.id
  route_table_id = aws_route_table.rt_igw.id
}

resource "aws_route_table_association" "pub_b" {
  subnet_id      = aws_subnet.pub_sbn_b.id
  route_table_id = aws_route_table.rt_igw.id
}


resource "aws_security_group" "web" {
  name        = "ec2 sg"
  description = "ec2 web sg"
  vpc_id      = aws_vpc.example.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-web-sg"
  }
}