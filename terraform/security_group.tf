module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh_sg"
  description = "Security group for ssh comunication publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks    = ["0.0.0.0/0"]
  auto_ingress_with_self = []
}