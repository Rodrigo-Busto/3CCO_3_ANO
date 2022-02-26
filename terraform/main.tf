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
  access_key = "ASIAQMPI7DF6D3E5LR65"
  secret_key = "PTBANGeWSWk80m0Y7CPu7i3tSvzNWn4UA7WRuqSB"
  token = "FwoGZXIvYXdzEGkaDIwqV63jv3DeDrlaJiLFAU9qGA+cu/P7CHbtH9/TV9dGZWdCt9mYnLBEmvkOfQ6NnxZDerQF6HInYeBffFkdbiMCrQ602wRecEtGAd+2WHbqCbNjGD5k8Kpv3ginpVvEoyp8ciOg76XKGpjbbbX5iAkAV/qaokjBSeP2i1hi8KEVY5EBTrInW6/8jHD7VaOXQApyRiAfd5LH9OCU5cnVSa8MdAUxOL9s0Dyuhk89LbYCqnCkJwrV0cuEDqV+Lhe5/glyASfcn4iwDw7n8WSfqeaaMTXCKK/b5ZAGMi0ABepenzN8Ed9d3NyC6bXPiOgMt7JGyhkPTbp52MIvPmQgNuRZyO3M9XTn4rc="
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "projeto_pi"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = false
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
  vpc_security_group_ids = [module.ssh_sg.security_group_id, module.jupyter_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#TODO gerar chave
resource "aws_key_pair" "jupyter_key" {
  key_name = "jupyter_key"
  public_key = "<SECRET>"
}

# TODO fechar infress all
module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh"
  description = "Security group for ssh comunication publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

#TODO abrir egress all
module "jupyter_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jupyter-port"
  description = "Security group for jupyter port publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8888
      to_port     = 8888
      protocol    = "tcp"
      description = "Jupyter Lab ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}