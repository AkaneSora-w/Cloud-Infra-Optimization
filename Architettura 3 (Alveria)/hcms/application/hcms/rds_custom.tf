resource "random_password" "custom_rds_password" {
  length           = 12
  special          = true
  override_special = "_%@"
}

module "rds_custom_mssql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.5.5"


  identifier = "${local.prefix}-mssql-custom"

  engine               = var.rds_custom_mssql_config.engine
  engine_version       = var.rds_custom_mssql_config.engine_version
  family               = var.rds_custom_mssql_config.family               # DB parameter group
  major_engine_version = var.rds_custom_mssql_config.major_engine_version # DB option group major
  instance_class       = var.rds_custom_mssql_config.instance_class
  allocated_storage    = var.rds_custom_mssql_config.allocated_storage
  storage_type         = var.rds_custom_mssql_config.storage_type

  username                    = var.rds_custom_mssql_config.username
  password                    = random_password.custom_rds_password.result
  manage_master_user_password = false
  port                        = 1433

  custom_iam_instance_profile = aws_iam_instance_profile.rds_profile.name
  kms_key_id                  = var.rds_custom_mssql_config.kms_key_arn

  db_subnet_group_name   = var.rds_custom_mssql_config.db_subnet_group_name # Review this , not found in state file
  create_db_subnet_group = var.rds_custom_mssql_config.create_db_subnet_group
  subnet_ids             = var.rds_custom_mssql_config.subnet_ids
  vpc_security_group_ids = [module.sg_custom_mssql.security_group_id]
  availability_zone      = var.networking.az["rds_custom"] == "" ? var.networking.az["ec2"] : var.networking.az["rds_custom"]

  create_cloudwatch_log_group = false

  skip_final_snapshot = false
  deletion_protection = true

  create_monitoring_role = true
  monitoring_role_name   = "${local.prefix}-custom-mssql"

  create_db_parameter_group       = false
  parameter_group_use_name_prefix = false
  parameter_group_name            = null
  parameters                      = []

  create_db_option_group       = false
  option_group_name            = null
  option_group_use_name_prefix = false
  options                      = []


  timezone           = var.rds_custom_mssql_config.timezone
  character_set_name = var.rds_custom_mssql_config.character_set_name

  db_instance_tags = { Schedule = var.schedule_tag.rds }
}

module "rds_custom_mssql_new" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.5.5"


  identifier = "${local.prefix}-mssql"

  engine               = var.rds_custom_mssql_config_new.engine
  engine_version       = var.rds_custom_mssql_config_new.engine_version
  family               = var.rds_custom_mssql_config_new.family               # DB parameter group
  major_engine_version = var.rds_custom_mssql_config_new.major_engine_version # DB option group major
  instance_class       = var.rds_custom_mssql_config_new.instance_class
  allocated_storage    = var.rds_custom_mssql_config_new.allocated_storage
  storage_type         = var.rds_custom_mssql_config_new.storage_type

  username                    = var.rds_custom_mssql_config_new.username
  password                    = random_password.custom_rds_password.result
  manage_master_user_password = false
  port                        = 1433

  custom_iam_instance_profile = aws_iam_instance_profile.rds_profile.name
  kms_key_id                  = var.rds_custom_mssql_config_new.kms_key_arn

  db_subnet_group_name   = var.rds_custom_mssql_config_new.db_subnet_group_name # Review this , not found in state file
  create_db_subnet_group = var.rds_custom_mssql_config_new.create_db_subnet_group
  subnet_ids             = var.rds_custom_mssql_config_new.subnet_ids
  vpc_security_group_ids = [module.sg_custom_mssql.security_group_id]
  availability_zone      = var.networking.az["ec2"]

  create_cloudwatch_log_group = false

  skip_final_snapshot = false
  deletion_protection = true

  create_monitoring_role = false
  monitoring_role_name   = "${local.prefix}-custom-mssql"

  create_db_parameter_group       = false
  parameter_group_use_name_prefix = false
  parameter_group_name            = null
  parameters                      = []

  create_db_option_group       = false
  option_group_name            = null
  option_group_use_name_prefix = false
  options                      = []


  timezone           = var.rds_custom_mssql_config_new.timezone
  character_set_name = var.rds_custom_mssql_config_new.character_set_name

  db_instance_tags = { Schedule = var.schedule_tag.rds }
}

module "sg_custom_mssql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.2"

  name        = "${local.prefix}-custom-mssql-sg"
  description = "Security group for ${local.prefix}-custom-mssql"
  vpc_id      = var.networking.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 1433
      to_port                  = 1433
      protocol                 = "tcp"
      description              = "Allow ec2 hcms connection on port 1433"
      source_security_group_id = module.sg_hcms.security_group_id

    },
    {
      from_port                = 1433
      to_port                  = 1433
      protocol                 = "tcp"
      description              = "Allow vpn connection on port 1433"
      source_security_group_id = var.networking.sg_vpn_id

    }
  ]

  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "Allow all traffic"
    cidr_blocks = "0.0.0.0/0"
  }]
}