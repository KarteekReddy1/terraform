terraform {
  backend "s3" {
    bucket         = "my1-terraform1-states1"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type

  # ✅ FIX
  subnet_id = data.aws_subnets.default.ids[0]

  tags = {
    Name = "${terraform.workspace}-jenkins-ec2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}
