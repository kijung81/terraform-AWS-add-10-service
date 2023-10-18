data "aws_ami" "al2" {
  most_recent = true

  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["*amzn2-ami-hvm*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web1" {
  ami           = data.aws_ami.al2.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.pub_sbn_a.id
  vpc_security_group_ids = [aws_security_group.web.id]
  associate_public_ip_address = true
  key_name      = var.ec2_key
  tags = {
    Name = "${var.prefix}-web1"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo amazon-linux-extras install -y nginx1
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF  
}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.al2.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.pub_sbn_b.id
  vpc_security_group_ids = [aws_security_group.web.id]
  associate_public_ip_address = true
  key_name      = var.ec2_key
  tags = {
    Name = "${var.prefix}-web2"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo amazon-linux-extras install -y nginx1
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF  
}
