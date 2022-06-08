module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "master-node"

  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t2.micro"
  key_name               = local.key_name
  monitoring             = true
  vpc_security_group_ids = [module.ssh_sg.security_group_id, module.spark_sg.security_group_id]
  subnet_id              = data.aws_subnet.public_subnet.id
  user_data              = file("./startup-master.sh")
  private_ip             = "10.100.0.139"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "worker_instances" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
  count   = 1

  name                   = "worker-node-${count.index}"
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t2.micro"
  key_name               = local.key_name
  monitoring             = true
  vpc_security_group_ids = [module.ssh_sg.security_group_id, module.spark_sg.security_group_id]
  subnet_id              = data.aws_subnet.public_subnet.id
  user_data              = file("./startup-worker.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh_sg"
  description = "Security group for ssh comunication publicly open"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_cidr_blocks    = ["0.0.0.0/0"]
  auto_ingress_with_self = []
}

module "spark_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "spark-port"
  description = "Security group for spark ui port publicly open"
  vpc_id      = data.aws_vpc.vpc.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Spark UI port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 7077
      to_port     = 7077
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 4040
      to_port     = 4040
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Egress ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["stack-jupyter-sptech"]
  }
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["stack-jupyter-sptech-public"]
  }
}

