include "root" {
	path = find_in_parent_folders()
}

inputs = {
    #VPC
    vpc_cidr                   = "10.100.0.0/16"
    public_subnets             = ["10.100.10.0/24", "10.100.11.0/24", "10.100.12.0/24"]
    app_private_subnets        = ["10.100.20.0/24", "10.100.21.0/24", "10.100.22.0/24"]
    db_private_subnets         = ["10.100.30.0/24", "10.100.31.0/24", "10.100.32.0/24"]
    use_centralized_nat        = false
    central_transit_gateway_id = "tgw-0515fff6b303036ba"
    vpc_mode                   = "dedicated"

    #ACM
    certificates = {
        "hcms" = {
            domain_name               = "hcms.tesi.awslab.epsilonline.com"
            subject_alternative_names = ["*.hcms.tesi.awslab.epsilonline.com"]
            zone_id = "Z0634106WYOVLBE1QCJT"
        }
        "collaudo.hcms" = {
            domain_name               = "collaudo.hcms.tesi.awslab.epsilonline.com"
            subject_alternative_names = ["*.collaudo.hcms.tesi.awslab.epsilonline.com"]
            zone_id = "Z0634106WYOVLBE1QCJT"
        }
        "prod.hcms" = {
            domain_name               = "prod.hcms.tesi.awslab.epsilonline.com"
            subject_alternative_names = ["*.prod.hcms.tesi.awslab.epsilonline.com"]
            zone_id = "Z0634106WYOVLBE1QCJT"
        }
    }

    #EC2 OPENVPN
    ec2_openvpn_config = {
        ami           = "ami-0a636034c582e2138"
        instance_type = "t4g.small"
        volume_size   = 10
    }

    #Scheduler
    schedule_tag = {
        ec2 = "it-office-hours"
    }

    #Conditional variables
    create_kms_key = true

####----Informazioni aggiuntivi per test----####
    owner = "alveria3"
    environment = "prod-wind3"
    service_name = "middleware-wind3"
####----------------------------------------####
}