######################################
# HCMS
######################################
module "ec2_hcms" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6.1"

  create = var.ec2_hcms_config["hcms"].create

  availability_zone = var.networking.az["ec2"]

  name                   = local.prefix
  ami                    = var.ec2_hcms_config["hcms"].ami
  instance_type          = var.ec2_hcms_config["hcms"].instance_type
  key_name               = var.ec2_hcms_config["hcms"].key_name
  vpc_security_group_ids = concat(try([module.sg_hcms.security_group_id], []), [var.networking.sg_vpn_id])
  subnet_id              = var.ec2_hcms_config["hcms"].subnet_id

  iam_instance_profile = aws_iam_instance_profile.ec2_iam_profile.name

  user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {

    UNATTEND_XML_FILE_PATH = "C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Sysprep\\Unattend.xml"
    EU_TIMEZONE            = "W. Europe Standard Time"

  }))

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.ec2_hcms_config["hcms"].volume_size
      tags = {
        Name = local.prefix
      }
    },
  ]
  enable_volume_tags = false

  tags = {
    Name     = local.prefix,
    Schedule = var.schedule_tag.ec2_hcms
    Backup   = var.backup_tag.hcms
  }
}

module "sg_hcms" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"

  create      = var.ec2_hcms_config["hcms"].create
  name        = "${local.prefix}-sg"
  description = "Security group for ${local.prefix}"
  vpc_id      = var.networking.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allow alb connection on port 80"
      source_security_group_id = var.networking.sg_public_alb_id

    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "Allow alb connection on port 443"
      source_security_group_id = var.networking.sg_public_alb_id
    },
    {

      from_port                = 3389
      to_port                  = 3389
      protocol                 = "tcp"
      description              = "Allow RDP connection"
      source_security_group_id = var.networking.sg_vpn_id
    }
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

######################################
# HCMS CLONE
######################################
module "ec2_hcms_clone" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6.1"
  name    = "${local.prefix}-clone"

  create                 = var.ec2_hcms_config["hcms_clone"].create
  ami                    = var.ec2_hcms_config["hcms_clone"].ami
  instance_type          = var.ec2_hcms_config["hcms_clone"].instance_type
  key_name               = var.ec2_hcms_config["hcms_clone"].key_name
  vpc_security_group_ids = [module.sg_hcms.security_group_id]
  subnet_id              = var.ec2_hcms_config["hcms_clone"].subnet_id

  iam_instance_profile = aws_iam_instance_profile.ec2_iam_profile.name

  user_data = base64encode(templatefile("${path.module}/user_data.tftpl", {

    UNATTEND_XML_FILE_PATH = "C:\\ProgramData\\Amazon\\EC2-Windows\\Launch\\Sysprep\\Unattend.xml"
    EU_TIMEZONE            = "W. Europe Standard Time"

  }))

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.ec2_hcms_config["hcms_clone"].volume_size
      tags = {
        Name = "${local.prefix}-clone"
      }
    },
  ]
  enable_volume_tags = false

  tags = {
    Name     = "${local.prefix}-clone",
    Schedule = var.schedule_tag.ec2_hcms_clone
    Backup   = var.backup_tag.hcms_clone
  }
}

######################################
# Extra EBS HCMS
######################################

resource "aws_ebs_volume" "extra_hcms_ebs" {
  for_each          = var.ec2_hcms_config["hcms"].extra_ebs
  availability_zone = var.networking.az["ec2"]
  size              = var.ec2_hcms_config["hcms"].extra_ebs[each.key].size
  encrypted         = true
  type              = "gp3"

}

resource "aws_volume_attachment" "extra_ebs_hcms_attach" {
  for_each    = var.ec2_hcms_config["hcms"].extra_ebs
  device_name = each.key
  volume_id   = aws_ebs_volume.extra_hcms_ebs[each.key].id
  instance_id = module.ec2_hcms.id
}

######################################
# Extra EBS HCMS CLONE
######################################

resource "aws_ebs_volume" "extra_hcms_clone_ebs" {
  for_each          = var.ec2_hcms_config["hcms_clone"].extra_ebs
  availability_zone = var.networking.az["ec2"]
  size              = var.ec2_hcms_config["hcms_clone"].extra_ebs[each.key].size
  encrypted         = true
  type              = "gp3"
}

resource "aws_volume_attachment" "extra_ebs_hcms_clone_attach" {
  for_each    = var.ec2_hcms_config["hcms_clone"].extra_ebs
  device_name = each.key
  volume_id   = aws_ebs_volume.extra_hcms_clone_ebs[each.key].id
  instance_id = module.ec2_hcms_clone.id
}

######################################
# FTP Server
######################################
module "ec2_ftp_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6.1"

  name = "${local.prefix}-ftp"

  create                      = var.ec2_ftp_server.create
  ami                         = var.ec2_ftp_server.ami
  instance_type               = var.ec2_ftp_server.instance_type
  key_name                    = var.ec2_ftp_server.key_name
  vpc_security_group_ids      = [module.sg_ftp.security_group_id]
  subnet_id                   = try(aws_subnet.dmz[0].id, "missing dmz_cidr_block")
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_iam_profile.name


  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = var.ec2_ftp_server.volume_size
      tags = {
        Name = "${local.prefix}-ftp"
      }
    },
  ]
  enable_volume_tags = false

  tags = {
    Name   = "${local.prefix}-ftp",
    Backup = var.backup_tag.ftp
  }

  depends_on = [aws_subnet.dmz]
}
module "sg_ftp" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"

  create      = var.ec2_ftp_server.create
  name        = "${local.prefix}-ftp-sg"
  description = "Security group for ${local.prefix} ftp"
  vpc_id      = var.networking.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 20
      to_port     = 22
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"

    },
    {
      from_port   = 4000
      to_port     = 5000
      protocol    = "tcp"
      description = "Passive mode ports"
      cidr_blocks = "0.0.0.0/0"

    }
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

  depends_on = [aws_subnet.dmz]

}