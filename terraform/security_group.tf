module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh_sg"
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

module "mysql_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/mysql"

  name        = "mysql"
  description = "Security group for mysql ports from internet"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}