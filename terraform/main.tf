terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "<ACCESS_KEY>"
  secret_key = "<SECRET>"
  token      = "<TOKEN>"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "projeto_pi"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "jupyter-instance"

  ami                    = "ami-04505e74c0741db8d"
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

resource "aws_key_pair" "jupyter_key" {
  key_name   = "jupyter-instance-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDiVqN2wVjshA8kZeSX2slBKFCdS+lZeYpfBFLfxVKi7VlsaFvayLHYmk5GArSL7BujQbqx126LY8/KX6QgT+YmhYlpCYcFn0d4bfSMGAdB7P3YKhHShK9v8lA3SFbiu26POFrVJuDApXiZifkaSb7cVem+ZuPnYIkCFGxE70ewmtkSvKEo/6CZBJMBJa6kco/SFcXFckE4ibX4M2TDBWsQMMYpHqC6+gCI7u/TYjf4XI0+44cLOERA0tswI/U8/kF4ni17ZSruHlDD6AHBNfRlCdj2t7oNfLZWhDRlDtOY36JsADWXaAZlhvvOLchRUHey9N3OynD/YbJrAs1Xy9u2OgXACaC9HHIXZac+32LZf1yZ7nBqXCpZ2uxZ/+jypKPbFOAMJSoUPYn6QmJKbw8A9KB9wGHCHrEE9bzWo8KamBDXgB+mXyq9yDDOtvOllJr3G89q8WCQ+GTXBvF8QvWxTnCtLz4Yhe22m+FMaTiNIRYBNeNV+QBNIlXzk3GBw30= rodrigo@DESKTOP-77PB1AB"
}

module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh"
  description = "Security group for ssh comunication publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks    = ["0.0.0.0/0"]
  auto_ingress_with_self = []
}

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
      description = "Jupyter Lab port"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Jupyter Lab ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

resource "null_resource" "provisioning_jupyter" {
  triggers = {
    instance = module.ec2_instance.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("../jupyter-instance-key.pem")
    host        = module.ec2_instance.public_ip
  }

  provisioner "file" {
    source      = "./jupyter-instance/"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu", "sh startup.sh"
    ]
  }
}
