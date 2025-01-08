include {
	path = find_in_parent_folders()
}

terraform {
	source = "../../modules/ec2"
}

locals {
	common_tags = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = {
	ami_id = "ami-0d64bb532e0502c46"
	instance_type = "t2.micro"
	inst_tags = merge(local.common_tags.inputs, 
		{Name = "prod-instance", 
		Enviroment = "prod"}
	)
}