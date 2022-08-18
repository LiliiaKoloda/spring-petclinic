provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.0.7"
}

variable "key_path" {
  default = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "id_rsa_key" {
  key_name   = "id_rs.pub"
  public_key = file("${var.key_path}")
}

resource "aws_instance" "instance" {
  ami                         = "ami-052efd3df9dad4825"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.id_rsa_key.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = "subnet-0ad84fb7ebd44abdd"
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
  name        = "Spring-petclinic-SG"
  description = "Spring-petclinic server"

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

  vpc_id = "vpc-0dbd95301c6eb292c"

  tags = {
    Name = "Spring-petclinic-Server-SG"
  }
}

output "instance-private-ip" {
  value = aws_instance.instance.private_ip
}

output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}