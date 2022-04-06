module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "database-instance"

  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.default_key
  monitoring             = true
  vpc_security_group_ids = [data.aws_security_group.ssh_sg]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

data "aws_security_group" "ssh_sg"{
    name = "ssh_sg"
}

data "aws_key_pair" "default_key" {
  key_name = "default-instance-key"
}

resource "null" "provisioner" {
  
}