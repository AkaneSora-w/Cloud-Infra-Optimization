include "root" {
	path = find_in_parent_folders()
}

terraform {
	source = "../../modules/ec2"
}

locals {
	common_tags = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

inputs = {
	ami_id = "ami-0d64bb532e0502c46" //valore ami in input
	instance_type = "t2.micro"
	/*aws_region = "eu-west-1"
	inst_name = "dev-instance-v2"
	tag_enviroment = "dev"*/
	inst_tags = merge(local.common_tags.inputs, 
		{Name = "dev-instance", Enviroment = "dev"})
	
}