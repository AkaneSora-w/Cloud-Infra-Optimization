include "root" {
	path = find_in_parent_folders("root.hcl")
}

dependency "wind" {
    config_path = "../../../middleware/terragruntEnv/alveria-prod-wind3"
}

locals {
    rds_mysql = read_terragrunt_config(find_in_parent_folders("common.hcl"))

}

inputs = {
    #Global
    service_name = "hcms"

    # Networking
    networking = {
        vpc_id                        = dependency.wind.outputs.vpc_id
        route53_zone_id               = dependency.wind.outputs.route53_zones
        sg_public_alb_id              = dependency.wind.outputs.public_alb_info.security_group_id
        alb_public_https_listener_arn = dependency.wind.outputs.alb_http_arn
        alb_public_http_listener_arn  = dependency.wind.outputs.alb_https_arn
        alb_public_dns_name           = dependency.wind.outputs.public_alb_info.dns_name
        alb_public_zone_id            = dependency.wind.outputs.public_alb_info.zone_id 
        sg_vpn_id                     = dependency.wind.outputs.vpn_sgid
        az = {
            ec2        = "eu-west-1a"
            rds_custom = "eu-west-1c"
        }
    }

    hcms_tg_cfg = {
        port                    = "80"
        health_check_path       = "/"
        domain_names            = ["w3timeline-admin.prod.hcms.it", "w3timeline-apiservice.prod.hcms.it", "w3timeline.prod.hcms.it", "w3timeline-erec-apiservice-collaudo.prod.hcms.it", "w3timeline-elearning.prod.hcms.it"]
        collaudo_domain_names   = ["w3timeline-admin.collaudo.hcms.it", "w3timeline-apiservice.collaudo.hcms.it", "w3timeline.collaudo.hcms.it"]
        formazione_domain_names = ["w3formazione.prod.hcms.it", "w3formazione.collaudo.hcms.it"]
        backoffice_domain_names = ["peoplehub-backoffice.prod.hcms.it", "peoplehub-backoffice.collaudo.hcms.it", "peoplehub-frontline.prod.hcms.it", "peoplehub-frontline.collaudo.hcms.it"]
    }

    # EC2
    ec2_hcms_config = {
        "hcms" = {
            create        = true
            ami           = "ami-05ed85bb0a2680064"
            instance_type = "t3a.xlarge"
            subnet_id     = "subnet-0f4cae047b947ae81"
            volume_size   = 50
            key_name      = "alveria-middleware-prod-key"
        },
        "hcms_clone" = {
            create        = true
            ami           = "ami-05ed85bb0a2680064"
            instance_type = "t3a.xlarge"
            subnet_id     = "subnet-0f4cae047b947ae81"
            volume_size   = 70
            key_name      = "alveria-middleware-prod-key"
            extra_ebs = {
                "xvdb" = {
                    size = 500
                }
            }
        }
    }

    # RDS MSSQL
    rds_custom_mssql_config = merge(local.rds_mysql.locals.rds_custom_mssql_config, {
        kms_key_arn            = dependency.wind.outputs.kms_arn
        db_subnet_group_name   = "alveria-middleware-prod"
        create_db_subnet_group = false #Please investiigate ,change if necessary
        subnet_ids             = []

    })

    rds_custom_mssql_config_new = merge(local.rds_mysql.locals.rds_custom_mssql_config_new, {
        kms_key_arn            = dependency.wind.outputs.kms_arn
        db_subnet_group_name   = "alveria-middleware-prod"
        create_db_subnet_group = false #Please investiigate ,change if necessary
        subnet_ids             = []
    })
    
    # Scheduler
    schedule_tag = {
        ec2_hcms       = "stopped"
        ec2_hcms_clone = "it-office-hours"
        rds            = "it-office-hours"
    }

    backup_tag = {
        hcms       = null
        hcms_clone = "true"
        ftp        = "true"
    }
}
