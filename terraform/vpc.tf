module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "projeto-3CCO-grupo9-vpc"
  cidr = "172.16.9.0/24"

  azs             = ["us-east-1a"]
  private_subnets = ["172.16.9.0/25"]
  private_subnet_tags = {
    access_type = "private"
  }

  public_subnets  = ["172.16.9.128/25"]
  public_subnet_tags = {
    access_type = "public"
  }

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = {
    Terraform   = "true"
  }
}

