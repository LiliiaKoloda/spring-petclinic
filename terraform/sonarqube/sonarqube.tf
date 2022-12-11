provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.0.7"
}



resource "aws_instance" "instance" {
  ami                         = "ami-0574da719dca65348"
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = "subnet-0aafce39a8d7e85e1"
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Spring-petclinic-Server"
  }
}

resource "aws_security_group" "sg" {
  name        = "Sonarqube"
  description = "Sonarqube"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "vpc-0e0f0e5d43611f9ee"

  tags = {
    Name = "Sonarqube"
  }
}

output "instance-private-ip" {
  value = aws_instance.instance.private_ip
}

output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}