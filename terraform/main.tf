terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "<ACCESS_KEY>"
  secret_key = "<SECRET_KEY>"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "projeto_pi"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "jupyter-instance"

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.jupyter_key.key_name
  monitoring             = true
  vpc_security_group_ids = [module.jupyter_sg.id]
  subnet_id              = module.vpc.public_subnets[0].id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_key_pair" "jupyter_key" {
  key_name = "jupyter_key"
  public_key = "<SECRET>"
}

module "jupyter_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "jupyterlab"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.id

  ingress_cidr_blocks = ["10.10.0.0/16"]
}