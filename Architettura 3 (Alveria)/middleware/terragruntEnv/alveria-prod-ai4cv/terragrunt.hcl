include "root" {
	path = find_in_parent_folders()
}

terraform {
	source = "../../application/middleware"
}

inputs = {
    #VPC
    vpc_cidr            = "10.200.0.0/16"
    public_subnets      = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]
    app_private_subnets = ["10.200.10.0/24", "10.200.11.0/24", "10.200.12.0/24"]
    db_private_subnets  = ["10.200.20.0/24", "10.200.21.0/24", "10.200.22.0/24"]
    use_centralized_nat = true
    vpc_mode            = "dedicated"
    create_alb          = false

    #ACM
    certificates = {}

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
    create_kms_key = false
}