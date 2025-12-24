terraform {
  backend "s3" {
    bucket         = "my1-terraform1-states1" # S3 bucket for state
    key            = "ec2/terraform.tfstate"  # Base path, workspace name auto-appended
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # Optional: for state locking
    encrypt        = true
  }
}

data "aws_vpc" "default" {
  default = true

}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

provider "aws" {
  region = var.region
}

# Example EC2 resource
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "${terraform.workspace}-jenkins-ec2"
  }
}

# Output the public IP for Jenkins pipeline to capture
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}