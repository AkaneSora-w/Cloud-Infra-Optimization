include "root" {
	path = find_in_parent_folders()
}

inputs = {
    #vpc
    vpc_cidr            = "10.101.0.0/16"
    public_subnets      = ["10.101.0.0/24", "10.101.1.0/24", "10.101.2.0/24"]
    app_private_subnets = ["10.101.10.0/24", "10.101.11.0/24", "10.101.12.0/24"]
    db_private_subnets  = ["10.101.20.0/24", "10.101.21.0/24", "10.101.22.0/24"]
    public_subnet_ids   = ["subnet-0c6a6036b343ff845", "subnet-0d8429e76bce79c73", "subnet-0072c66f3734849e2"]
    
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

    #Conditional variables
    create_kms_key        = false
    create_alb            = true
    create_kms_key_shared = true

####----Informazioni aggiuntivi per test----####
    vpc_mode            = "dedicated"
    ec2_openvpn_config = {
        ami           = "ami-0a636034c582e2138"
        instance_type = "t4g.small"
        volume_size   = 10
    }
    environment = "prod-shrd"
    service_name = "middleware-shrd"
####----------------------------------------####
}

