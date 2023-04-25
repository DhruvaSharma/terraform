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

resource "aws_instance" "app_server" {
  ami           = "ami-06e46074ae430fba6"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

resource "aws_vpc" "terraform-vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "terraform-subnet" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "terraform_subnet"
  }
}