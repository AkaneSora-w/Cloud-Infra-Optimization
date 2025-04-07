include "root" {
	path = find_in_parent_folders("root.hcl")
    # expose = true
}

dependency "shared" {
    config_path = "../../../middleware/terragruntEnv/shared"
}

locals {
    rds_mysql = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = {
    #Global
    service_name = "acme-shared"

    # Networking
    networking = {
        vpc_id                        = dependency.shared.outputs.vpc_id
        route53_zone_id               = ""
        sg_public_alb_id              = dependency.shared.outputs.public_alb_info.security_group_id
        alb_public_https_listener_arn = dependency.shared.outputs.alb_http_arn
        alb_public_http_listener_arn  = dependency.shared.outputs.alb_https_arn
        alb_public_dns_name           = dependency.shared.outputs.public_alb_info.dns_name
        alb_public_zone_id            = dependency.shared.outputs.public_alb_info.zone_id    
        sg_vpn_id                     = dependency.shared.outputs.vpn_sgid
        dmz_cidr_block                = "10.101.3.0/24"
        az = {
            ec2        = "eu-west-1c"
            rds_custom = "eu-west-1c"
        }
    }

    acme_tg_cfg = {
        port                        = "80"
        health_check_path           = "/"
        domain_names                = ["apiaws.prod.acme.it", "art-admin.prod.acme.it", "art.prod.acme.it", "damico-admin.prod.acme.it", "damico.prod.acme.it"]
        testing_domain_names       = ["apiaws.testing.acme.it", "art-admin.testing.acme.it", "art.testing.acme.it", "damico-admin.testing.acme.it", "damico.testing.acme.it"]
        zefiro_domain_names         = ["zefiro.testing.acme.it", "zefiro-admin.testing.acme.it", "connectorapi.testing.acme.it"]
        jakala_domain_names         = ["jakala-admin.testing.acme.it", "jakala.testing.acme.it"]
        connector_api2_domain_names = ["connectorapi-02.testing.acme.it"]
    }

    # EC2
    ec2_acme_config = {
        "acme" = {
            create        = true
            ami           = "ami-09c5bdfbb0284812b"
            instance_type = "t3a.xlarge"
            subnet_id     = "subnet-05bee404114c72ddd"
            volume_size   = 50
            key_name      = "architettura3-middleware-prod-key"
            extra_ebs = {
            "xvdb" = {
                size = 500
            }
            }
        },
        "acme_clone" = {
            create        = false
            ami           = ""
            instance_type = ""
            subnet_id     = ""
            volume_size   = 0
            key_name      = ""
        }
    }

    # RDS MSSQL
    rds_custom_mssql_config = merge(local.rds_mysql.locals.rds_custom_mssql_config, {
        kms_key_arn            = dependency.shared.outputs.shared_kms_arn
        db_subnet_group_name   = ""
        create_db_subnet_group = true
        subnet_ids             = [dependency.shared.outputs.list_db_subnet[0], dependency.shared.outputs.list_db_subnet[1], dependency.shared.outputs.list_db_subnet[2]]
    })

    rds_custom_mssql_config_new = merge(local.rds_mysql.locals.rds_custom_mssql_config_new, {
        kms_key_arn            = dependency.shared.outputs.shared_kms_arn
        db_subnet_group_name   = ""
        create_db_subnet_group = true
        subnet_ids             = [dependency.shared.outputs.list_db_subnet[0], dependency.shared.outputs.list_db_subnet[1], dependency.shared.outputs.list_db_subnet[2]]
    })

    # Scheduler
    schedule_tag = {
        ec2_acme       = "it-office-hours"
        ec2_acme_clone = "stopped"
        rds            = "it-office-hours"
    }

    backup_tag = {
        acme       = "true"
        acme_clone = null
        ftp        = "true"
    }

    # EC2 FTP
    ec2_ftp_server = {
        create        = true
        ami           = "ami-0600784ba5c5c8073"
        instance_type = "t4g.small"
        volume_size   = 500
        key_name      = "architettura3-middleware-prod-key"
    }
}