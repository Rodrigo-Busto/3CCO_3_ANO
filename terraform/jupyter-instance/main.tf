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
    private_key = file("../../jupyter-instance-key.pem")
    host        = module.ec2_instance.public_ip
  }

  provisioner "file" {
    source      = "./startup/"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source      = "../install_docker.sh"
    destination = "/home/ubuntu"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu", "sh install_docker.sh", "sh startup.sh"
    ]
  }
}