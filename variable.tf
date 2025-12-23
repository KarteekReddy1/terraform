variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-068c0051b15cdb816" # Amazon Linux 2 AMI (update for your region)
}

variable "instance_type" {
  default = "t3.micro"
}