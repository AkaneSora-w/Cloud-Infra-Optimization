module "ec2_openvpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6.1"
  count   = local.create_openvpn ? 1 : 0

  name = "${local.prefix}-openvpn"

  ami                    = var.ec2_openvpn_config.ami
  instance_type          = var.ec2_openvpn_config.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [module.sg_openvpn[0].security_group_id]
  subnet_id              = element(module.vpc[0].public_subnets, 0)

  iam_instance_profile = aws_iam_instance_profile.ec2_iam_profile.name

  user_data = file("${path.module}/userdata.sh")

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.ec2_openvpn_config.volume_size
      tags = {
        Name = "${local.prefix}-openvpn"
      }
    },
  ]
  enable_volume_tags = false

  tags = {
    Name     = "${local.prefix}-openvpn",
    Schedule = var.schedule_tag.ec2
    Backup   = "true"
  }
}

moved {
  from = module.ec2_openvpn
  to   = module.ec2_openvpn[0]
}

module "sg_openvpn" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"
  count   = local.create_openvpn ? 1 : 0

  name        = "${local.prefix}-openvpn-sg"
  description = "Security group for ${local.prefix}-openvpn"
  vpc_id      = module.vpc[0].vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH connection"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS connection"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 943
      to_port     = 943
      protocol    = "tcp"
      description = "OpenVPN service port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1194
      to_port     = 1194
      protocol    = "udp"
      description = "OpenVPN service port"
      cidr_blocks = "0.0.0.0/0"
    },

  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "All traffic"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

}

moved {
  from = module.sg_openvpn
  to   = module.sg_openvpn[0]
}
######################################
# EIP
######################################

resource "aws_eip" "openvpn_ip" {
  count    = local.create_openvpn ? 1 : 0
  instance = module.ec2_openvpn[0].id
  domain   = "vpc"
  tags = {
    Name = "${local.prefix}-openvpn"
  }
}

resource "aws_eip_association" "openvpn_ip_assoc" {
  count         = local.create_openvpn ? 1 : 0
  instance_id   = module.ec2_openvpn[0].id
  allocation_id = aws_eip.openvpn_ip[0].id
}

