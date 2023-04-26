terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

// Create vpc

resource "aws_vpc" "exercise_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "exercise_vpc"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "exercise_gw" {
  vpc_id = aws_vpc.exercise_vpc.id

  tags = {
    Name = "exercise_gateway"
  }
}

// Create Custom Route Table

resource "aws_route_table" "exercise_rt" {
  vpc_id = aws_vpc.exercise_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.exercise_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.exercise_gw.id
  }

  tags = {
    Name = "exercise_rt"
  }
}
// Create a Subnet

resource "aws_subnet" "exercise_subnet" {
  vpc_id            = aws_vpc.exercise_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "exercise_subnet"
  }
}
// Associate subnet with Route Table

resource "aws_route_table_association" "exercise_rt_association" {
  subnet_id      = aws_subnet.exercise_subnet.id
  route_table_id = aws_route_table.exercise_rt.id
}
// Create Security Group to allow port 22,80,443

resource "aws_security_group" "exercise_sg" {
  name        = "exercise_sg"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.exercise_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "exercise_sg"
  }
}
// Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "exercise_nic" {
  subnet_id       = aws_subnet.exercise_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.exercise_sg.id]

}
// Assign an elastic IP to the network interface created in step 7

resource "aws_eip" "exercise_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.exercise_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.exercise_gw, aws_instance.exercise_instance]
}
// Create Ubuntu server and install/enable apache2

resource "aws_instance" "exercise_instance" {
  ami               = "ami-0aa2b7722dc1b5612"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "terraform_exercise"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.exercise_nic.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "exercise_instance"
  }
}


// to print outputs from state list
// value = resource.propertyname

# output "server_ip" {
#   value = aws_eip.public_ip
# }


# variable "subnet_prefix" {
#   description = "cidr block for the subnet"

# }

// variable usage and declaration

# resource "aws_vpc" "prod-vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = "production"
#   }
# }

# resource "aws_subnet" "subnet-1" {
#   vpc_id            = aws_vpc.prod-vpc.id
#   cidr_block        = var.subnet_prefix[0].cidr_block
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = var.subnet_prefix[0].name
#   }
# }

# resource "aws_subnet" "subnet-2" {
#   vpc_id            = aws_vpc.prod-vpc.id
#   cidr_block        = var.subnet_prefix[1].cidr_block
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = var.subnet_prefix[1].name
#   }
# }
